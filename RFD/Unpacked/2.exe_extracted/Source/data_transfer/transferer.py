# Standard library imports
import dataclasses
import queue
import uuid

# Typing imports
from typing import Any


@dataclasses.dataclass
class _input_type:
    path: str
    guid: str
    args: tuple[Any, ...]


class obj_type:
    def __init__(self):
        super().__init__()
        self.was_triggered = False
        self.input_queue = queue.Queue[_input_type]()
        self.output_dict = dict[str, queue.Queue[_input_type]]()
        self.batch_limit = 10000000000000000  # Наш лимит на мега-пакет (до 1 млн элементов)

    def _generate_guid(self) -> str:
        while True:
            guid = str(uuid.uuid4())
            if guid not in self.output_dict:
                return guid

    def call(self, path: str, game_config, *call_args):
        temp_queue = queue.Queue()
        guid = self._generate_guid()
        self.output_dict[guid] = temp_queue

        self.input_queue.put(_input_type(
            path=path,
            guid=guid,
            args=call_args,
        ))

        result = temp_queue.get(block=True)
        del self.output_dict[guid]
        return result

    def extract(self) -> dict[str, dict[str, Any]]:
        '''
        Оптимизированный метод: полностью убран таймаут блокировки.
        Выгребает абсолютно ВСЕ элементы из очереди в один мега-батч и мгновенно отдает их.
        '''
        self.was_triggered = True
        result = {}
        items_count = 0

        # Жадный цикл: забираем всё, что накопилось в очереди, без блокировки и задержек
        while items_count < self.batch_limit:
            try:
                item = self.input_queue.get_nowait()
                result[item.guid] = dataclasses.asdict(item)
                items_count += 1
            except queue.Empty:
                break  # Если очередь пуста, сразу выходим и отдаем то, что успели собрать

        return result

    def insert(self, data: dict[str, Any]) -> None:
        # Быстрая вставка ответов обратно в потоки
        for guid, result in data.items():
            if guid in self.output_dict:
                self.output_dict[guid].put(result)
