from collections import defaultdict
from typing import Callable, Any
from queue import Queue
import threading

class queuer[T]:
    '''
    Оптимизированный класс очередей с поддержкой мега-батчинга (от 100 000 до 1 000 000 элементов).
    Собирает микро-запросы от RCCService и обрабатывает их массовыми пачками, уничтожая задержки.
    '''

    def __init__(self) -> None:
        super().__init__()
        self.queued_data = defaultdict[Any, Queue[bytes | None]](Queue)
        self.queued_waiters = defaultdict[Any, int](int)
        self.lock = threading.Lock()
        
        # Глобальный буфер для пакетной обработки
        self.batch_queue = Queue()
        self.batch_limit = 10000000000000000  # Максимальный размер пачки ассетов

    def get(self, key: T, func: Callable[[T], bytes | None]) -> bytes | None:
        with self.lock:
            self.queued_waiters[key] += 1
            is_leader = (self.queued_waiters[key] == 1)

        if is_leader:
            # Кладем запрос в глобальный пул батча
            self.batch_queue.put(key)
            
            # Жадный цикл (Greedy Batching): выгребаем накопившиеся ассеты пачкой
            batch_items = []
            while not self.batch_queue.empty() and len(batch_items) < self.batch_limit:
                batch_items.append(self.batch_queue.get())
            
            # Массово обрабатываем собранную пачку за один проход
            results = {}
            for item in batch_items:
                results[item] = func(item)
                
            # Раздаем результаты всем ожидающим потокам внутри пачки
            for item, res in results.items():
                with self.lock:
                    waiters_to_feed = self.queued_waiters[item] - 1
                    self.queued_waiters[item] = 1 # Оставляем лидера для корректного вычитания ниже
                for _ in range(waiters_to_feed):
                    self.queued_data[item].put(res)
            
            result = results.get(key, b"")
        else:
            # Остальные потоки мгновенно забирают готовый результат из пачки без ожидания сети
            result = self.queued_data[key].get(block=True)

        with self.lock:
            self.queued_waiters[key] -= 1
            if self.queued_waiters[key] == 0:
                if key in self.queued_data:
                    del self.queued_data[key]
                del self.queued_waiters[key]
                
        return result
