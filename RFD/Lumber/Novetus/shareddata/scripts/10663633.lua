--player
player = nil
--selected
selected = false
--save shoulders
RSH, LSH = nil, nil
--grip
GRP = nil
--welds
RW, LW = Instance.new("Weld"), Instance.new("Weld")
--what anim
anim = "none"

--create the dustcloud object
local prt = Instance.new("Part")
prt.Size = Vector3.new(1,1,1)
prt.BrickColor = BrickColor.new(217)
prt.Anchored = true
prt.CanCollide = false
script.Parent.CloudMesh.Parent = prt
--[[local msh = Instance.new("SpecialMesh")
msh.MeshId = "http://www.roblox.com/asset/?id=1095708"
msh.MeshType = 5
msh.Parent = prt]]

----- show version ----------
script.Parent.Name = "BanHammer V1.1"
---------------------------------

function WaitForChild(obj, ch_n)
	local t = time()
	while not obj:FindFirstChild(ch_n) and time() - t < 10 do wait(0.1) end
	return obj:FindFirstChild(ch_n)
end

--onselected, save shoulders and get player
script.Parent.Equipped:connect(function()
	if selected then return end
	selected = true
	player = game.Players:playerFromCharacter(script.Parent.Parent)
	local ch = script.Parent.Parent
	WaitForChild(ch, "Torso")
	RSH = WaitForChild(ch.Torso, "Right Shoulder")
	LSH = WaitForChild(ch.Torso, "Left Shoulder")
	GRP = WaitForChild(ch["Right Arm"], "RightGrip")
	_G.Grip = GRP
	--
	RSH.Part1 = nil
	LSH.Part1 = nil
	--
	RW.Part0 = ch.Torso
	RW.C0 = CFrame.new(1.5, 0.5, 0) --* CFrame.fromEulerAnglesXYZ(1.3, 0, -0.5)
	RW.C1 = CFrame.new(0, 0.5, 0)
	RW.Part1 = ch["Right Arm"]
	RW.Parent = ch.Torso
	_G.R = RW
	--
	LW.Part0 = ch.Torso
	LW.C0 = CFrame.new(-1.5, 0.5, 0) --* CFrame.fromEulerAnglesXYZ(1.7, 0, 0.8)
	LW.C1 = CFrame.new(0, 0.5, 0)
	LW.Part1 = ch["Left Arm"]
	LW.Parent = ch.Torso
	_G.L = LW
	--
	GRP.C0 = CFrame.new(0, -1, 0) * CFrame.fromEulerAnglesXYZ(-1, 0, 0)
	--Bring_Arm_Up animation
	for i = 0, 1, 0.05 do
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.3*i, 0, -0.5*i)
		LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.7*i, 0, 0.8*i)	
		LW.C1 = CFrame.new(-0.3*i, 0.5+1.2*i, 0)
	end
	--put in grip
	wait()
	local rg = (ch["Right Arm"]:FindFirstChild("RightGrip") or GRP)
	if rg ~= GRP then
		GRP.Parent = ch["Right Arm"]
		rg:remove()
	end
end)

--griptcf = CFrame.new(0, -1, 0) * CFrame.fromEulerAnglesXYZ(-math.pi/2+0.5, 0, 0)

script.Parent.Unequipped:connect(function()
	selected = false
	local pl = player
	--Bring_Arm_Down animation
	for i = 1, 0, -0.05 do
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.3*i, 0, -0.5*i)
		LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.7*i, 0, 0.8*i)	
		LW.C1 = CFrame.new(-0.3*i, 0.5+1.2*i, 0)
	end
	RW.Parent = nil
	LW.Parent = nil
	RSH.Part1 = pl.Character["Right Arm"]
	LSH.Part1 = pl.Character["Left Arm"]
end)

function HomeRunHit(part)
	local h = (part.Parent or game):FindFirstChild("Humanoid") --or findfirstchild optimization
	if h then
		game.Soundscape.Bomb:Play()
		h.Sit = true
		wait()
		h.Jump = true
		h.Parent.Torso.Velocity = (CFrame.new(script.Parent.Handle.Position, h.Parent.Torso.Position).lookVector * 200) + Vector3.new(0, 100, 0)
		h.Parent.Torso.RotVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
	end
end

function HomeRun()
	for i = 0, 1, 0.1 do
		if anim ~= "homerun" then return end
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.3+1.2*i, -0.5*i, -0.5+i)
		--R.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(2.5, -0.5, 0.5)
		LW.C0 = CFrame.new(-1.5+0.5*i, 0.5, -0.5*i) * CFrame.fromEulerAnglesXYZ(1.7, 0, 0.8)	
		--L.C0 = CFrame.new(-1.0, 0.5, -0.5) * CFrame.fromEulerAnglesXYZ(1.7, 0, 1)
	end
	--start homerunhit connection--
	local con = script.Parent.Handle.Touched:connect(HomeRunHit)
	----------------------------------------
	for i = 0, 1, 0.2 do
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(2.5, -0.5-1.7*i, 0.5+0.5*i)
		--R.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(2.5, -2.2, 1)
		LW.C0 = CFrame.new(-1-0.5*i, 0.5, -0.5+0.5*i) * CFrame.fromEulerAnglesXYZ(1.7, 0, 0.8-1.2*i)	
		LW.C1 = CFrame.new(0, 0.5-i, 0)
		GRP.C0 = CFrame.new(0, -1, 0) * CFrame.fromEulerAnglesXYZ(-1-2*i, 0, 0)
	end
	for i = 0, 1, 0.2 do
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(2.5, -2.2-0.6*i, 1)
	end
	wait(0.1)
	----end homerun connection---
	con:disconnect()
	--------------------------------------
	for i = 0, 1, 0.1 do
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(2.5-1.2*i, -2.8+2.8*i, 1-1.5*i)
		--RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.3, 0, -0.5)
		LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.7, 0, -0.4+1.2*i)	
		LW.C1 = CFrame.new(0, -0.5+i*2, 0)
		--LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.7, 0, 0.8)
		GRP.C0 = CFrame.new(0, -1, 0) * CFrame.fromEulerAnglesXYZ(-3+2*i, 0, 0)
	end
end

function Whack()
	for i = 0, 1, 0.2 do
		if anim ~= "norm" then return end
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.3+i, 0, -0.5+0.5*i)
		LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.7-0.25*i, 0, 0.8-0.6*i)	
	end
	for i = 0, 1, 0.25 do
		if anim ~= "norm" then return end
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(2.3-2.5*i, 0, 0)
		LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.45-0.25*i, 0, 0.2)	
		GRP.C0 = CFrame.new(0, -1, 0) * CFrame.fromEulerAnglesXYZ(-1-0.5*i, 0, 0)
	end
	--insert camshake and hit nearby people
	for _, p in pairs(game.Players:GetChildren()) do
		if p.Character:FindFirstChild("Torso") then
			if (p.Character.Torso.Position - (script.Parent.Handle.CFrame*CFrame.new(0, 3, 0)).p).magnitude < 30 then
				local s = script.Parent._CamShake:clone()
				s.Disabled = false
				s.Parent = p.Backpack
				if p ~= player then
					p.Character.Humanoid.Sit = true
					delay(0.1, function() p.Character.Humanoid.Jump = true end)
					p.Character.Torso.RotVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
				end
			end
		end
	end
	--add dust cloud
	local pt = prt:clone()
	pt.Position = (script.Parent.Handle.CFrame*CFrame.new(0, 3, -1.5)).p
	pt.Parent = game.Workspace
	delay(0, function()
		for i = 0, 1, 0.3 do
			pt.CloudMesh.Scale = Vector3.new(1+14*i, 1+14*i, 1+14*i)
			wait()
		end
		for i = 0, 1, 0.4 do
			pt.CloudMesh.Scale = Vector3.new(15-8*i, 15-8*i, 15-8*i)
			pt.Transparency = i
			wait()
		end
		pt:remove()
	end)
	------
	for i = 0, 1, 0.2 do
		if anim ~= "norm" then return end
		wait()
		RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(-0.2+1.5*i, 0, -0.5*i)
		LW.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(1.2+0.5*i, 0, 0.2+0.6*i)	
		GRP.C0 = CFrame.new(0, -1, 0) * CFrame.fromEulerAnglesXYZ(-1.5+0.5*i, 0, 0)
	end
end

local a = false
local co = nil
--OMGHAX mouseclick
local last_click = 0
script.Parent.MouseClick.Changed:connect(function()
	if time() - last_click < 0.3 then
		anim = "homerun"
		last_click = time()
		HomeRun()
	else
		anim = "norm"
		last_click = time()
		Whack()
	end
end)