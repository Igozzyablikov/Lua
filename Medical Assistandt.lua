script_name("Medical Assistant")
script_author("Melanie Hate")
script_version("22042020")

require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local sampev = require "lib.samp.events"
local inicfg = require "inicfg"
local directIni = "Medical_Assistant.ini"
local mainIni = inicfg.load(nil , directIni)
if mainIni == nil then
    ini = {config = {pnumber = "", sex = "M", mainOrganization = "", organization = "", rank = "", position = "", tag = ""}}
    inicfg.save(ini, directIni)
    mainIni = inicfg.load(nil, directIni)
end

local script_hint = "� {FFc800}[���������]{FFFFFF} "
local script_namem = "{FF827B}Medical Assistant{FFFFFF}"
local server = false
local action = false
local choice = false
local getInfo = false
if mainIni.config.sex == "M" then P1 = "" elseif mainIni.config.sex == "F" then P1 = "�" end
if mainIni.config.sex == "M" then P2 = "" elseif mainIni.config.sex == "F" then P2 = "��" end
if mainIni.config.sex == "M" then P3 = "��" elseif mainIni.config.sex == "F" then P3 = "����" end
if mainIni.config.sex == "M" then P4 = "��" elseif mainIni.config.sex == "F" then P4 = "��" end
if mainIni.config.sex == "M" then P5 = "��" elseif mainIni.config.sex == "F" then P5 = "���" end
if mainIni.config.sex == "M" then P6 = "��" elseif mainIni.config.sex == "F" then P6 = "���" end

local function sendChatArray(arr, wait_time)
	for line_num = 1, table.getn(arr) do
		current_line = arr[line_num]
		if line_num ~= 1 then wait(wait_time) end
		sampSendChat(current_line)
	end
end

local function addChatMessageArray(arr, wait_time)
	for line_num = 1, table.getn(arr) do
		current_line = arr[line_num]
		if line_num ~= 1 then wait(wait_time) end
		sampAddChatMessage(current_line, -1)
	end
end

function update()
    local fpath = os.getenv("TEMP") .. "\\testing_version.json"
    downloadUrlToFile("https://raw.githubusercontent.com/Igozzyablikov/Lua/master/Medical_Assistant.json", fpath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        local f = io.open(fpath, "r")
            if f then
                local info = decodeJson(f:read("*a"))
                updateLink = info.updateLink
                if info and info.latest then
                    version = tonumber(info.latest)
                    if version > tonumber(thisScript().version) then
                        lua_thread.create(function()
                            sampAddChatMessage(script_hint .. "���������� ����� ������ lua " .. script_namem .. ". �������� ����������.", -1)
                            downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
                                if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                    sampAddChatMessage(script_hint " Lua " .. script_namem .. " ������� �� ��������� ������.", -1)
                                    thisScript():reload()
                                end
                            end)
                        end)
                    else
                        update = false
                    end
                end
            end
        end
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    update()
    serverIP, _ = sampGetCurrentServerAddress()
    if serverIP == "51.83.207.242" then
    --if serverIP == "127.0.0.1" then
        server = true
        sampRegisterChatCommand("color", function(arg) print(sampGetPlayerColor(arg)) end)
        sampRegisterChatCommand("mhelp", function()
            if mainIni.config.mainOrganization == "MH" then
                sampShowDialog(10000, script_namem .. " | ������", "{FF827B}/mhelp{FFFFFF} � ������.\n{FF827B}/mm{FFFFFF} � ����.\n\n{FF827B}/heal{FFFFFF} � ������ ��������.\n{FF827B}/medcard{FFFFFF} � ������ ���. �����.\n{FF827B}/vac{FFFFFF} � ������� ����������.\n{FF827B}/diagnos{FFFFFF} � ��������� �������.\n{FF827B}/procedure{FFFFFF} � �������� ���������.\n{FF827B}/setsex{FFFFFF} � �������� �������� �� ����� ����.\n{FF827B}/possion{FFFFFF} � ������������ ������� �����������.\n\n{FF827B}/invite{FFFFFF} � ������� � �����������.\n{FF827B}/uninvite{FFFFFF} � ������� �� �����������.\n{FF827B}/uninviteoff{FFFFFF} � ������� �� �����������. {AAAAAA}(offline){FFFFFF}\n{FF827B}/fwarn{FFFFFF} � ������ ��������������.\n{FF827B}/fwarnoff{FFFFFF} � ������ ��������������. {AAAAAA}(offline){FFFFFF}\n{FF827B}/unfwarn{FFFFFF} � ����� ��������������.\n{FF827B}/rang{FFFFFF} � �������� ��� �������� � ���������.\n{FF827B}/setskin{FFFFFF} � ������ �����.\n\n����� ������������ ������� ��� ���������, ���������� ��������� ����� �������.\n{AAAAAA}(/heal � /heall, /invite � /invitee  � �.�.){FFFFFF}\n\n{FF827B}�{FFFFFF} ����� lua � {FF827B}Melanie Hate{FFFFFF}.\n{FF827B}�{FFFFFF} Discord: {FF827B}JeEn.Off#2585{FFFFFF}.", "�������", "", 0)
            else
                sampAddChatMessage(script_hint .. "�� �� ��������� {FF827B}��{FFFFFF}. ������� " .. script_namem .. " ��� ��� ����������.", -1)
            end
        end)
        sampRegisterChatCommand("mm", function() if mainIni.config.mainOrganization == "MH" then lua_thread.create(cmd_mm) end end)
        sampRegisterChatCommand("heal", cmd_heal)
        sampRegisterChatCommand("heall", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/heal " .. arg) end end)
        sampRegisterChatCommand("medcard", cmd_medcard)
        sampRegisterChatCommand("medcardd", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/medcard " .. arg) end end)
        sampRegisterChatCommand("vac", cmd_vac)
        sampRegisterChatCommand("vacc", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/vac " .. arg) end end)
        sampRegisterChatCommand("setsex", cmd_setsex)
        sampRegisterChatCommand("setsexx", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/setsex " .. arg) end end)
        sampRegisterChatCommand("passion", cmd_passion)
        sampRegisterChatCommand("passionn", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/passion " .. arg) end end)
        sampRegisterChatCommand("diagnos", cmd_diagnos)
        sampRegisterChatCommand("diagnoss", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/diagnos " .. arg) end end)
        sampRegisterChatCommand("procedure", cmd_procedure)
        sampRegisterChatCommand("proceduree", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/procedure " .. arg) end end)
        sampRegisterChatCommand("invite", cmd_invite)
        sampRegisterChatCommand("invitee", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/invite " .. arg) end end)
        sampRegisterChatCommand("division", cmd_division)
        sampRegisterChatCommand("divisionn", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/division " .. arg) end end)
        sampRegisterChatCommand("uninvite", cmd_uninvite)
        sampRegisterChatCommand("uninvitee", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/uninvite " .. arg) end end)
        sampRegisterChatCommand("uninviteoff", cmd_uninviteoff)
        sampRegisterChatCommand("uninviteofff", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/uninviteoff " .. arg) end end)
        sampRegisterChatCommand("fwarn", cmd_fwarn)
        sampRegisterChatCommand("fwarnn", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/fwarn " .. arg) end end)
        sampRegisterChatCommand("fwarnoff", cmd_fwarnoff)
        sampRegisterChatCommand("fwarnofff", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/fwarnoff " .. arg) end end)
        sampRegisterChatCommand("unfwarn", cmd_unfwarn)
        sampRegisterChatCommand("unfwarnn", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/unfwarn " .. arg) end end)
        sampRegisterChatCommand("rang", cmd_rang)
        sampRegisterChatCommand("rangg", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/rang " .. arg) end end)
        sampRegisterChatCommand("setskin", cmd_setskin)
        sampRegisterChatCommand("setskinn", function(arg) if mainIni.config.mainOrganization == "MH" then sampSendChat("/setskin " .. arg) end end)
    else
        sampAddChatMessage(script_hint .. "Lua " .. script_namem .. " �������� ������ �� Diamond RP Amber.", -1)
    end

    _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    myNickname = sampGetPlayerNickname(myId)

    while true do
        wait(0)
        if isKeyDown(0xA4) and isKeyJustPressed(0x31) then
            sampSendChat("������������, � ���� ����� " .. myNickname:gsub("_", " ") .. ". ��� ��� ���������?")
        end
    end
end

function cmd_mm()
    sampShowDialog(10001, script_namem .. " | ����", "{FF827B}[1]{FFFFFF} �������� {FF827B}[info]{FFFFFF}\n{FF827B}[2]{FFFFFF} ������", "�������", "�������", 2)
    while sampIsDialogActive() do
        wait(0)
        local result, button, list, input = sampHasDialogRespond(10001)
        if result and button == 0 then
        elseif result and list == 0 then
            sampShowDialog(10002, script_namem .. " | ��������", "{FFFFFF}������: ������.\n{FF827B}�{FFFFFF} ������������� ������. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ������� ������ ����������� �����. {AAAAAA}(������){FFFFFF}\n\n������������ �����: ������.\n{FF827B}�{FFFFFF} ������ ��� ����. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ������ �� �����. {AAAAAA}(���������� ��){FFFFFF}\n\n�������: ������.\n{FF827B}�{FFFFFF} ������. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ��������� ����. {AAAAAA}(��������� ����� � ����){FFFFFF}\n\n�������: ������.\n{FF827B}�{FFFFFF} ������������� �����. {AAAAAA}(��������){FFFFFF}\n\n��������: ������.\n{FF827B}�{FFFFFF} �������. {AAAAAA}(�� ����� ����� ����){FFFFFF}\n\n��������: ������.\n{FF827B}�{FFFFFF} ���. {AAAAAA}(�������� �������){FFFFFF}\n\n��������: ������.\n{FF827B}�{FFFFFF} �� ����� ����� � ������������ ��������.\n\n������������: ������.\n{FF827B}�{FFFFFF} �� ����� �������� �� �����, ���������, �������.\n\n���������: ������������ �1.\n{FF827B}�{FFFFFF} ����������� ������. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ������. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ������� �� ������ �����. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ������ ��� ����.\n\n������ ������: ������������ �2.\n{FF827B}�{FFFFFF} �����. {AAAAAA}(��������){FFFFFF}\n{FF827B}�{FFFFFF} ������� �� �����. {AAAAAA}(���������� ��){FFFFFF}\n{FF827B}�{FFFFFF} ����������� � ������. {AAAAAA}(������� �����){FFFFFF}", "�������", "", 0)
        elseif result and list == 1 then
            sampShowDialog(10003, script_namem .. " | ������", "{FF827B}[1]{FFFFFF} �����������\n{FF827B}[2]{FFFFFF} ������ ���. ����\n{FF827B}[3]{FFFFFF} ���������� � ���������\n{FF827B}[4]{FFFFFF} ���������� � ������ 9-1-1\n{FF827B}[5]{FFFFFF} ������� � �����\n{FF827B}[6]{FFFFFF} ����� �� ���\n{FF827B}[7]{FFFFFF} ����� MoH\n{FF827B}[8]{FFFFFF} ������ � �����", "�������", "�������", 2)
            lua_thread.create(function()
                while sampIsDialogActive() do
                    wait(0)
                    local result, button, list, input = sampHasDialogRespond(10003)
                    if result and button == 0 then
                    elseif result and list == 0 then
                        action = true
                        lecture1 = {
                            "��������� ��������, ��������� ��������.",
                            "������ � ������ ������ �� ���� ������������ 1-�� �����.",
                            "��� ����������� �� ������, ��� ����� ����� �������.",
                            "������� ������� �� 4-� ������: ����� ��, ������, ��, ���� �����.",
                            "� ���� ���� ����� ������������ �� ����������� ������� ���������.",
                            "������� ������ � ������ ����� ����. ����� ��� �����������.",
                            "����� ����� �������� ������, �� ���������� ����� � ����������� �����...",
                            "...� ������������ Medical Academy.",
                            "����� �������� ������, �� ������ ���������� �� 2-� ����.",
                            "���� ������� �� ��������."
                        }
                        sendChatArray(lecture1, 2222)
                        action = false
                    elseif result and list == 1 then
                        action = true
                        lecture2 = {
                            "��������� ��������, ��������� ��������.",
                            "������ � ������ ������ �� ���� ������� ���. ����.",
                            "�������� �������� ������-������������, ������� �������...",
                            "...���������� �� �������� �����������, ������� �...",
                            "..������������ ��������.",
                            "������ ���. ���� �������� ����� �� ������� ������������...",
                            "...����� - ���������.",
                            "� ��������� ������� ������, ������������������ �������,",
                            "� ������� ����������� ������ ���. ������ ���������.",
                            "����� ������� ����. ������� ��������, ���� - ��������...",
                            "...������ ������� ��������� � ���. ����� ��������, � �����...",
                            "...��������� ������ ��������.",
                            "��� ���������� ���. ����� �������� ������ ���������...",
                            "...������� � ����������. � ������ �������� � ��������...",
                            "...��������� �������� ���. �����.",
                            "���� ������� �� ��������."
                        }
                        sendChatArray(lecture2, 2222)
                        action = false
                    elseif result and list == 2 then
                        action = true
                        lecture3 = {
                            "��������� ����������, ��������� ��������.",
                            "������ � ������ ������ �� ���� ����������� � ����������.",
                            "������������� - ����, �������� ������������� � ������� ����������.",
                            "� �� ��� ��������� � ��������� ������ �������� ������ ��������� �...",
                            "...�����������.",
                            "����� ������ � ������������� ������� ������� ��������...",
                            "...������� � ���������, ������� ���� ������ ��������.",
                            "���������� ��������� ����������� � � ��� ���� ���������...",
                            "...������ �������. ����� �����, ��� � ����.",
                            "������� ���������� � ��������� ����� ������ ������...",
                            "...������������������ ���� - ����������.",
                            "��� ������ ����� ���� �������������� ���������.",
                            "���� ������� �� ��������."
                        }
                        sendChatArray(lecture3, 2222)
                        action = false
                    elseif result and list == 3 then
                        action = true
                        lecture4 = {
                            "��������� ��������, ��������� ��������.",
                            "������ � ������ ������ �� ���� ����������� � ������ 9-1-1�.",
                            "������������� ������ �������� ������������� � ������� ����������.",
                            "�������� �������� ������-���������� ��� ������������� �������� ���.",
                            "��� ��� ���� ����� �������, ������� � ������������� ������������.",
                            "������������� �������� ��� ������ ������ ���� ����� � ������ �...",
                            "...����� �����. ���� ���-�� ����� ��� ������� � ��� ���������...",
                            "...� ������.",
                            "� ����� ���, ������ ������ ���� � ����� ���. �����...",
                            "...� ���� ���. ����������� ���� �����������. �������� ������...",
                            "...������ � �� ������ �����������, ������� ����� ���� ������...",
                            "...��������������!",
                            "��������� ������������� �������, �� ������������� ��������.",
                            "���� ������� �� ��������."
                        }
                        sendChatArray(lecture4, 2222)
                        action = false
                    elseif result and list == 4 then
                        action = true
                        lecture5 = {
                            "��������� ��������, ��������� ��������.",
                            "������ � ������ ������ �� ���� �������� � ������.",
                            "������� - ������������ ����� ������� 9-1-1.",
                            "���������� ��������� �������, ������� ����� ��������������.",
                            "������ ��������� Amber Emergency Medical Services ���������� ������, � �������...",
                            "...������� �� ����� ��������� ����� ������ � ��� ��� ���� ��������.",
                            "������ � ����� ������� ������� - ��� ������ �������������� ������",
                            "/n Role Play ����� ��� Non RP.",
                            "������ � ����������� ��������� �� ������������...",
                            "...��������� ��������� ������ ���������.",
                            "���������� ����. ������ �Ambulance� ����� �����...",
                            "...��������� ����� ������ � ����� ����� ���������...",
                            "��� ��������.",
                            "��������� � ����������� ����� ������� � 3-� �������.",
                            "1-�: ����� �� �����. 2-�: �������� � �������� ���.",
                            "3-�: ����������� �� ��������� ������� ��� �������������� ��������.",
                            "��� ������� �������� � ����������� �����.",
                            "���� ������� �� ��������.",
                        }
                        sendChatArray(lecture5, 2222)
                        action = false
                    elseif result and list == 5 then
                        action = true
                        lecture6 = {
                            "��������� ��������, ��������� ��������.",
                            "������ � ������ ������ �� ���� ������ �� ���.",
                            "������� ���� ���� ��������� � ������, � ����� �����...",
                            "...� ������� ������� ��������� ������.",
                            "���������� ������� �������� � �� ����� ��� ������� �...",
                            "...��������� ���. ������.",
                            "� ������ �������������, ���������� ������� ��������� �������������...",
                            "...� ��������� ���-���. �����, ����������� c�������� ��������.",
                            "���� ������� �� ��������."
                        }
                        sendChatArray(lecture6, 2222)
                        action = false
                    elseif result and list == 6 then
                        action = true
                        lecture7 = {
                            "��������� ��������, ��������� ��������.",
                            "������ � ������ ������ �� ���� ������ MoH�.",
                            "������ �� ������� ������ � �������� ����� ������ - ������ ����������.",
                            "����� MoH �������� ��������, ����������-�������� ����������.",
                            "����� �������� 11 �������, � ������� ����������� ����� ���������� � �� ������.",
                            "��������� ������ ������������ ������������� �����, ������ ��� � ���� �����...",
                            "...������ � ����� ����� ���������.",
                            "�� ������ ��������� ������ ��������� ����� ���� ������.",
                            "��� ��, ����� �������� �� ������ �� ������������ ���������,",
                            "��������� ��� ������� ������ ������ ������������� ���� 7 ����.",
                            "����� ���� ��������� ��������������� ������������.",
                            "� � ���������� ������ ����� �� �������, ������ ������ �������� � ���� �...",
                            "...������� �� ���������.",
                            "�� ���� � ���� ��. ���� ������� �� ��������."
                        }
                        sendChatArray(lecture7, 2222)
                        action = false
                    elseif result and list == 7 then
                        sampShowDialog(10004, script_namem .. " | ������ � �����", "{FF827B}[1]{FFFFFF} ������� ������ � ������\n{FF827B}[2]{FFFFFF} ��� � ������������ �����\n{FF827B}[3]{FFFFFF} �������� ������ �� ���. �� ���������������\n{FF827B}[4]{FFFFFF} ������ ��� �������� ���\n{FF827B}[5]{FFFFFF} ������ � ����� �����\n{FF827B}[6]{FFFFFF} ���. ���������� ���������� � ������ �����\n{FF827B}[7]{FFFFFF} ������������\n{FF827B}[8]{FFFFFF} ��������� ������� ��������", "�������", "�������", 2)
                        lua_thread.create(function()
                            while sampIsDialogActive() do
                                wait(0)
                                local result, button, list, input = sampHasDialogRespond(10004)
                                if result and button == 0 then
                                elseif result and list == 0 then
                                    action = true
                                    lecture1 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� ������� ��������� ���������� ������ � ������!",
                                        "/r �� ��������� ������� �������, �� ������ ���� ��������!"
                                    }
                                    sendChatArray(lecture1, 2222)
                                    action = false
                                elseif result and list == 1 then
                                    action = true
                                    lecture2 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� �� ��� � ������������ ����� �� ������ �������� �������!",
                                        "/r ��������� �� ��������, �� ���������!"
                                    }
                                    sendChatArray(lecture2, 2222)
                                    action = false
                                elseif result and list == 2 then
                                    action = true
                                    lecture3 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� �������� ������ ������������ ���������������..",
                                        "/r ..�� ����������� ��� �� ���������������!"
                                    }
                                    sendChatArray(lecture3, 2222)
                                    action = false
                                elseif result and list == 3 then
                                    action = true
                                    lecture4 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� ������ � �������� ���� ����� ������ ��� ������� �����!",
                                        "/r ������� �� ��������, �� ���������!"
                                    }
                                    sendChatArray(lecture4, 2222)
                                    action = false
                                elseif result and list == 4 then
                                    action = true
                                    lecture5 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� �� ������ �������� ��� � ������������� �����..",
                                        "/r ..�� ������ �������� ���������!"
                                    }
                                    sendChatArray(lecture5, 2222)
                                    action = false
                                elseif result and list == 5 then
                                    action = true
                                    lecture6 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� ������������� �������� ���������� �������..",
                                        "/r � ����� ����� ���������!"
                                    }
                                    sendChatArray(lecture6, 2222)
                                    action = false
                                elseif result and list == 6 then
                                    action = true
                                    lecture7 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� � ��������� ����� ���������� ����������� � ���������� �� \"��\".",
                                        "/r � ������ ��������� ������� �������, �� ������ �������� ���������!"
                                    }
                                    sendChatArray(lecture7, 2222)
                                    action = false
                                elseif result and list == 7 then
                                    action = true
                                    lecture8 = {
                                        "/r ��������� ����������, ����� ��������� ��������!",
                                        "/r ���� ��������� ���, ��� �� ��������� ������� �������� �� ������ ������� ���������!",
                                        "/r ������� �� ��������, �� ���������!"
                                    }
                                    sendChatArray(lecture8, 2222)
                                    action = false
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end
end

function cmd_heal(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+") then
                    local id = tonumber(arg:match("%d+"))
                    if id >= 0 and id < 1000 then
                        if id == myId then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    heal = {
                                        "/me ��������" .. P1 .. " ��������, � ��������" .. P1 .. " �������.",
                                        "/do ����������� ����� �� �����.",
                                        "/me ������" .. P1 .. " �� ����������� ����� ��������� � ������� ����.",
                                        "/me �������" .. P1 .. " ������� ���� � ��������� ��������.",
                                        "��� ��������������. ���� ���� �� ����������� - ��������� � �������� ��� ������������."
                                    }
                                    sendChatArray(heal, 2222)
                                    if sampGetPlayerColor(id) == 2868859556 then sampSendChat("/heal " .. id .. " 1")
                                    elseif sampGetPlayerColor(id) == 301989887 then sampSendChat("/heal " .. id .. " 200")
                                    else sampSendChat("/heal " .. id .. " 300") end
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /heal id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /heal id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_medcard(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+") then
                    local id = tonumber(arg:match("%d+"))
                    if id >= 0 and id < 1000 then
                        if id == myId then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    sampSendChat("���������, ����������, ���� ID-Card.")
                                    wait(2222)
                                    sampSendChat("/n /pass " .. myId)
                                    sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} ���������� {FF827B}[2]{FFFFFF} NonRP ��� {FF827B}[3]{FFFFFF} �������� ��������")
                                    choice = true
                                    while choice do
                                        wait(0)
                                        if isKeyJustPressed(0x31) then
                                            action = true
                                            medcard = {
                                                "/do �� ��� ����� ����������������.",
                                                "/me ���� ���������������� � ���, �������" .. P1 .. " ����� ����������������� � ���.",
                                                "/me ���� �������� ������������ �� �����, ������" .. P1 .. " ������������ ������ � �����.",
                                                "/me ���� ����������������, �������" .. P1 .. " ��� �� ���.",
                                                "/do ����������� ����� ����� �� �����.",
                                                "/me ����" .. P1 .. " ����������� ����� �� �����.",
                                                "/do �� ����� ����� �����.",
                                                "/me ����" .. P1 .. " ����� �� �����.",
                                                "/me ��������" .. P1 .. " ������� �� ������ ������ \"������\".",
                                                "/me ��������" .. P1 .. " ������� � ����� \"������� �����\".",
                                                "/me ������� ����� �� ����, ����" .. P1 .. " �� ����� ������ \"Ministry of Health\".",
                                                "/me ��������" .. P1 .. " ������ \"Ministry of Health\".",
                                                "/me �������" .. P1 .. " ����������� ����� ��������.",
                                                "/medcard " .. id .. ""
                                            }
                                            sendChatArray(medcard, 2222)
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x32) then
                                            sendchat("��������, � �� ���� ������ ��� ���. �����, � ��� �������� � ��������.")
                                            wait(2222)
                                            sendchat("/n /mn ? C���� ����� ����. ���������� ������: \"Name_Surname\".")
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x33) then
                                            sampAddChatMessage(script_hint .. "�� �������� �������� {FF827B}������ ���. �����{FFFFFF}.", -1)
                                            choice = false
                                        end
                                    end
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /medcard id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /medcard id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_vac(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+") then
                    local id = tonumber(arg:match("%d+"))
                    if id >= 0 and id < 1000 then
                        if id == myId then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    vac = {
                                        "/do �� ����� �����: ������, ������ � ���������.",
                                        "/me ����" .. P1 .. " ����� � ������ �� �����.",
                                        "/me ��������" .. P1 .. " ������ �������, ��������� ����� ����������.",
                                        "/do ����� �������� ���������� �� ������.",
                                        "/me ����� ����� �����" .. P2 .. "  ���� �� ������ ���� ��������.",
                                        "/me ����" .. P3 .. " ����� � ����, ����� �������" .. P1 .. " ���� � ����."
                                    }
                                    sendChatArray(vac, 2222)
                                    wait(100)
                                    sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} ����������  {FF827B}[2]{FFFFFF} ��������", -1)
                                    sampAddChatMessage(script_hint .. "{FF827B}[3]{FFFFFF} �������       {FF827B}[4]{FFFFFF} �������� ��������", -1)
                                    choice = true
                                    while choice do
                                        wait(0)
                                        if isKeyJustPressed(0x31) then
                                            if sampGetPlayerColor(id) == 301989887 then
                                                sampSendChat("/vac " .. id .. " 1 700")
                                            else
                                                sampSendChat("/vac " .. id .. " 1 1000")
                                            end
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x32) then
                                            if sampGetPlayerColor(id) == 301989887 then
                                                sampSendChat("/vac " .. id .. " 2 700")
                                            else
                                                sampSendChat("/vac " .. id .. " 2 1000")
                                            end
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x33) then
                                            if sampGetPlayerColor(id) == 301989887 then
                                                sampSendChat("/vac " .. id .. " 3 700")
                                            else
                                                sampSendChat("/vac " .. id .. " 3 1000")
                                            end
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x34) then
                                            sampAddChatMessage(script_hint .. "�� �������� �������� {FF827B}����������{FFFFFF}.", -1)
                                            choice = false
                                        end
                                    end
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /vac id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /vac id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_setsex(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+") then
                    local id = tonumber(arg:match("%d+"))
                    if id >= 0 and id < 1000 then
                        if id == myId then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    setsex = {
                                        "������� ���������� �� ������������ ����!",
                                        "/me �������� �� ����� �����, ������" .. P1 .. " �.",
                                        "/me ������ �� ����� ���������� ��������, �����" .. P1 .. " ��.",
                                        "/me ���� ����� ��� ������� � ���������, ����" .. P1 .. " � �� ���� ��������, ����� �������" .. P1 .. " ������ �������.",
                                        "/do ������� ����� ��� ������������ �������.",
                                        "/me ���� ��������� �� �����, �����" .. P4 .. "  � ��������.",
                                        "/me ������� ��������� � ������� �������, ������" .. P1 .. "  ������.",
                                        "/me ����� ��������� �� ����, ����" .. P1 .. " ����������� ���� � ����.",
                                        "/me ����������� ���������� �������" .. P1 .. " ��� �� ����� �������.",
                                        "/me ����� ��������, ����� �� ������, ��������" .. P1 .. " ������ �������.",
                                        "/me ����" .. P1 .. " ����� ��� ������� � ��������.",
                                        "/do ������� ���������.",
                                        "/do �������� ��������.",
                                        "/setsex " .. id .. ""
                                    }
                                    sendChatArray(setsex, 2222)
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /setsex id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /setsex id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_passion(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+%s+%d+") then
                    local id = tonumber(arg:match("(%d+)%s+"))
                    local days = tonumber(arg:match("%s+(%d+)"))
                    if id >= 0 and id < 1000 then
                        if days > 9 and days < 31 then 
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        passion = {
                                            "/me ������" .. P1 .. " ����������� �����, ����� ������" .. P1 .. " ������ �������� �� ����������� ����������.",
                                            "/me ������" .. P1 .. " ��������, � �������" .. P1 .. " �������� �� ����.",
                                            "/do �� ����� ����� ����� � ����������������� ���������.",
                                            "/me ������" .. P1 .. " �� ���. ����� ����� � ��������� �������.",
                                            "/me ������ �����, �������" .. P1 .. " ���� � �������� �����.",
                                            "/me �������� �����, ���������" .. P1 .. " ����� �����.",
                                            "/me ������� ����� � ����� �����, ����" .. P1 .. " ��������.",
                                            "/me ������" .. P1 .. " ���� �� ���.�����, ����� ��������" .. P1 .. " ���� � ����� �����."
                                        }
                                        sendChatArray(passion, 2222)
                                        wait(2222)
                                        sampSendChat("/passion " .. id ..  " " .. days ..  " " .. days*1000)
                                        action = false
                                    else
                                        sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /passion id ��� {AAAAAA}(�� 10 �� 30){FFFFFF}.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /passion id ��� {AAAAAA}(�� 10 �� 30){FFFFFF}.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /passion id ��� {AAAAAA}(�� 10 �� 30){FFFFFF}.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_diagnos(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+") then
                    local id = tonumber(arg:match("%d+"))
                    if id >= 0 and id < 1000 then
                        if id == myId then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    diagnos = {
                                        "/me ������" .. P1 .. " ����������� �����, ����� ���� ������" .. P1 .. " �� �� ������� � �����.",
                                        "/me ����������� �������� �������� ��������, �������" .. P1 .. " ������� � ����� �������.",
                                        "/todo �������� ������� � ������������.*������� ������ � ��������� ��� �������� ��������.",
                                        "/me �����" .. P1 .. " ������� � ����� � ���. �����, ����� ���� ������" .. P1 .. " �."
                                    }
                                    sendChatArray(diagnos, 2222)
                                    action = false
                                    wait(2222)
                                    sampSendChat("/diagnos " .. id)
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /diagnos id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /diagnos id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_procedure(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if arg:match("%d+") then
                    local id = tonumber(arg:match("%d+"))
                    if id >= 0 and id < 1000 then
                        if id == myId then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    sampShowDialog(10005, script_namem .. " | ���������", "{FF827B}[1]{FFFFFF} ������\n{FF827B}[2]{FFFFFF} ������������ �����\n{FF827B}[3]{FFFFFF} �������\n{FF827B}[4]{FFFFFF} �������\n{FF827B}[5]{FFFFFF} ��������\n{FF827B}[6]{FFFFFF} ��������\n{FF827B}[7]{FFFFFF} ��������\n{FF827B}[8]{FFFFFF} ������������\n{FF827B}[9]{FFFFFF} ���������\n{FF827B}[10]{FFFFFF} ������ ������", "�������", "�������", 2)
                                    lua_thread.create(function()
                                        while sampIsDialogActive() do
                                            wait(0)
                                            local result, button, list, input = sampHasDialogRespond(10005)
                                            if result and button == 0 then
                                            elseif result and list == 0 then
                                                action = true
                                                procedure1 = {
                                                    "�������������, ����������, �� �������.",
                                                    "/me ������" .. P1 .." ����������� �����, ����� ������" .. P1 .." ����� �������.",
                                                    "/todo ����������������� �� ���� ������ � ���������� ��������, ������� � ������.*�������� ����� �� ������� ������.",
                                                    "�������� ����� � ������� ��������.",
                                                    "��������� � ���-�� ������� � ���������� ������������.",
                                                    "/me �����" .. P1 .." ���������� ������ �� ��������������.",
                                                    "/todo �����������, ��� �� � ������, �� ����� ��� �������.*��������� ���������� ������.",
                                                    "/me ������� ������, ������" .. P1 .." �������� ��������������� �� ����������� �����.",
                                                    "������ ������� �����.",
                                                    "/todo �������� ������ � �������� ��������, ��� ��� �������.*��������� ������ � ��������.",
                                                    "/me ������" .. P1 .." ����������� �����."
                                                }
                                                sendChatArray(procedure1, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(5)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 1 then
                                                action = true
                                                procedure2 = {
                                                    "��������������, ����������, �� �������.",
                                                    "/me ������" .. P1 .." ����������� �����, ����� ������" .. P1 .." ��������� � ���������.",
                                                    "/me ���������" .. P1 .." ���������, ������� ��� ��������.",
                                                    "������� ��������� �����������, ���������� ����� ������� ��� ���������� ��������� �� ����������.",
                                                    "������� �������� ���������� ����� ��� � ������� ���������.",
                                                    "��������� �������� � ���, ������ �������� ��� ������, ��������� ���������� ������ �����.",
                                                    "����� �� ������� � ���������� ��������, ������� ��������, ����� ���������� ���� ���������.",
                                                    "����� �������� ����� � �������, ����� ��������� ��������� ������� � ������.",
                                                    "������� �������� ��� ���, �������� ��� � ��������� �� 10 ������ �������.",
                                                    "��������� ����� ��� � ��� ������������� ��������� ���������.",
                                                    "/todo ������ ��� ������ �����, ��������� ������ �������� ����, �����������, ���� �������� ����������.*�������� �����."
                                                }
                                                sendChatArray(procedure2, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 2 then
                                                action = true
                                                procedure3 = {
                                                    "������������ �� ���� � �������������, ����������, �� �����.",
                                                    "/me ������" .. P1 .." ��������, ������" .. P1 .." �������� � ������������, ����� ���� �������" .. P1 .." � �� ��������.",
                                                    "/me ������" .. P1 .." ����������� �����, ������" .. P1 .." ������ �������� �� ����������� ����������.",
                                                    "/me ������" .. P1 .." �������� � �������" .. P1 .." �������� �� ����.",
                                                    "/do �� �������� ����� ������� �������������� ����� � ������� �����.",
                                                    "/me ������" .. P1 .." �������� � ������������, ����� ��������" .. P1 .." �� � �����.",
                                                    "/me ��������" .. P1 .." �������� ��������� � ������� ������� ������ ��������.",
                                                    "/do � ��� �������� ����� ������ �������� ���������.",
                                                    "/me ����" .. P1 .." �������� ���������, ����� ���� ������" .. P1 .." ��� � ��� ����, ����� ��������" .. P1 .." ��������� �� ���������.",
                                                    "/todo ����� 5 ����� ��������� ����� ���������.*������ �������� � ������������ ������ �� ����� �����."
                                                }
                                                sendChatArray(procedure3, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(9)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 3 then
                                                action = true
                                                procedure4 = {
                                                    "������������ �� ���� � �������������, ����������, �� �����",
                                                    "/me ������" .. P1 .." ����������� �����, ������" .. P1 .." ������ �������� �� ����������� ����������.",
                                                    "/me ������" .. P1 .." ��������, ����� �������" .. P1 .." �������� �� ����.",
                                                    "/me ������" .. P1 .." ��������, � ������" .. P1 .." ������ ���������� ��������.",
                                                    "/todo ���������� ���.*���������� ��������",
                                                    "/me �����������" .. P1 .." �������� � ��������.",
                                                    "/me ������" .. P1 .." �� ����� ����������� ����, ����� ���� ���" .. P3 .." ��� �� ������ ���������.",
                                                    "/todo �������� ������.*�������� �������� � ������� ��������.",
                                                    "/me � ������� ������� ������" .. P1 .." ��������� ��������� ��������.",
                                                    "/me �������" .. P1 .." �������� �� �������.",
                                                    "/do �� �������� ���������� ���������.",
                                                    "/todo ��� ������� ��������� �����������.*���������� ������ ���������."
                                                }
                                                sendChatArray(procedure4, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(2)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 4 then
                                                action = true
                                                procedure5 = {
                                                    "�������������, ����������, �� �������.",
                                                    "/me ������" .. P1 .." ����������� �����, ������" .. P1 .." ������ �������� �� ����������� ����������.",
                                                    "/me ������" .. P1 .." ��������, ����� �������" .. P1 .." �������� �� ����.",
                                                    "/todo �������� �� ������ ���.*�������� �� ����� ����� �����.",
                                                    "/me ������ �� ������� ������� ������ � ������ �������, ��������" .. P5 .." � ��������.",
                                                    "/me ��������" .. P1 .." ��� ��������.",
                                                    "/do ������ � ������ ������� � ����.",
                                                    "/me ������" .. P1 .." ������ ����� ������, ����� ������" .. P1 .." ������.",
                                                    "/me ������������ � ��� ��������, �������" .. P1 .." ������ �������, ����� ���� ���� ������ ������ ������.",
                                                }
                                                sendChatArray(procedure5, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(6)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 5 then
                                                action = true
                                                procedure6 = {
                                                    "�������������, ����������, �� �������.",
                                                    "/me ������" .. P1 .." ����������� �����, ������" .. P1 .." ������ �������� �� ����������� ����������.",
                                                    "/me ������" .. P1 .." ��������, ����� �������" .. P1 .." �������� �� ����.",
                                                    "/me �����" .. P1 .." ����������� ���� ��������.",
                                                    "/me ������" .. P1 .." ������� ������ ��������.",
                                                    "/me �������" .. P1 .." ���������� �������� ����� � ������� ������.",
                                                    "/me ������" .. P1 .." �� ����� ������ ����, ����� ������" .. P1 .." ������, � �������" .. P1 .." ����� �� ������.",
                                                    "/me ����" .. P1 .." �������� ���� �� ���� ������� ������.",
                                                    "/todo ����������� �� ���.*������� ����� �������� ����.",
                                                    "/me ������� ����������� � ������� �����, �������" .. P1 .." ����, ����� ����" .. P1 .." ����������� �� �����.",
                                                    "/todo �������� ��������� �����.*������ �������� � ��������� �� � ����."
                                                }
                                                sendChatArray(procedure6, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(7)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 6 then
                                                action = true
                                                procedure7 = {
                                                    "�������������, ����������, �� ��� � �������� �����.",
                                                    "/me ������" .. P1 .." ����������� �����, ������" .. P1 .." ������ �������� �� ����������� ����������.",
                                                    "/me ������" .. P1 .." ��������, ����� �������" .. P1 .." �������� �� ����.",
                                                    "/me ������" .. P1 .." �� ����������� ����� �������� ������ �����.",
                                                    "/me ������� ��������, ����" .. P1 .." ���� ����� � ����.",
                                                    "/do ����� � ����.",
                                                    "/me ������ � ����� ��" .. P6 .." ����� � ������ �����.",
                                                    "/todo ������ �� ������� ����������� �����.*������ �������� � ��������� �� � ����."
                                                }
                                                sendChatArray(procedure7, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(1)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 7 then
                                                action = true
                                                procedure8 = {
                                                    "�������������, ����������, �� �����.",
                                                    "/me ������" .. P1 .." ����������� �����, ������" .. P1 .." ������ �������� �� ����������� ���������� � ����� ��� ���.",
                                                    "/me ������" .. P1 .." ��������, ����� �������" .. P1 .." �������� �� ����.",
                                                    "/me ������ ������ �������, ������ �������" .. P1 ..", ����� ���� ���������� ������� ��������� �� ������.",
                                                    "/me ����� ��������� ����� ������.",
                                                    "/me ���������" .. P1 .." ������������� ������� ������ ���������.",
                                                    "/me �������� ����� ������ �� ���� �����, �����" .. P4 .." � ������� �������� ��������.",
                                                    "/todo ������ �� ������� ����������.*�������� �� ���. ����� �����.",
                                                    "/todo ���� �������� ��� ���� ������ ����� ������.*���������� ����� �������� ��������."
                                                }
                                                sendChatArray(procedure8, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(8)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 8 then
                                                action = true
                                                procedure8 = {
                                                    "/me ������" .. P1 .." �� ���.����� �����, ������ � ���������� � ������������ ����.",
                                                    "/me ������ �����, �������" .. P1 .." ���� � �������� ������.",
                                                    "/me �������� �����, ���������" .. P1 .." ����� �����.",
                                                    "/me ������� ����� � ����� �����, ��" .. P6 .." �������� � ��������" .. P1 .." ����.",
                                                    "������������� ���� ���� �����."
                                                }
                                                sendChatArray(procedure8, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(4)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            elseif result and list == 9 then
                                                action = true
                                                procedure8 = {
                                                    "/do ��������� ������� ����� � ���. �����.",
                                                    "/me ������ ������� � ��������� ���������, ������" .. P1 .." �.",
                                                    "/me �������" .. P1 .." ��������� ������� �� ����.",
                                                    "/me ������ ������� � ��������� ���������, �������" .. P1 .." � � ����������� �����.",
                                                    "/me ������" .. P1 .." �������� � �������������� ���������� �� ���.�����.",
                                                    "/me ������" .. P1 .." ��������, ������� �������� �� ����.",
                                                    "/me c������ ������� ����������� �����, �������" .. P1 .." � �� ����.",
                                                    "/do ����������� ����� �������.",
                                                    "/me �������" .. P1 .." ������ �� �������� ����������������.",
                                                    "/me ����" .. P1 .." �� ����� ���������� �����, ����� �����������" .. P1 .." � � ������.",
                                                    "/me ���������" .. P1 .." ����� � ���������� ������� ��������.",
                                                    "/me �������" .. P1 .." ������ ������ ���������.",
                                                    "/do ������ ��������� ������.",
                                                    "/do ����� � �������� �� �����.",
                                                    "/me ����" .. P1 .." �����, ����� ���� ������" .. P1 .." ����������� ������.",
                                                    "/do ������ ������������.",
                                                    "/me ����" .. P1 .." ���������� ����������� � ����.",
                                                    "/me ����" .. P1 .." ����� ������������, ������ ������" .. P1 .." ��� ������� � ������� ����.",
                                                    "/me ��������� ��������" .. P1 .." ����������� ������� �������.",
                                                    "/me �������� ������������ ������ �������.",
                                                    "/me �����" .. P1 .." ������������ �����, ����� ���� �����" .. P3 .." ��� � ����.",
                                                    "/me ����� ���� ������" .. P1 .." ���� ���������.",
                                                    "/me ������" .. P5 .." � ��������.",
                                                    "/me ���� � ���� �������, �������" .. P1 .." �� �������� �������.",
                                                    "/me �����" .. P4 .." � ������������, � ������" .. P1 .." �����.",
                                                    "/do �� ����� ����� ��������� � ����������������� �������.",
                                                    "/me ����" .. P1 .." ��������� � ����, ������ ����� ������������, �����" .. P4 .." � ������������� �����.",
                                                    "/me ��������� ������� ����� � ����, ���������" .. P1 .." � �������������� ������ ��������.",
                                                    "/do �� ����� ������������ ���� � ������������� ����.",
                                                    "/me ���������" .. P1 .." � ��������� ����������� ����.",
                                                    "/do ������ ��������� ����� �������� ���� ��������� ������� � ������� ������ � ����.",
                                                    "/me ��������" .. P1 .." ���. ����������� �� ������.",
                                                    "/me ����" .. P1 .." ����������� ����� � ��������.",
                                                    "/me ��������" .. P1 .." ������� ������ ���������."
                                                }
                                                sendChatArray(procedure8, 2222)
                                                action = false
                                                wait(2222)
                                                sampSendChat("/procedure " .. id)
                                                while not sampIsDialogActive() do
                                                    wait(0)
                                                end
                                                sampSetCurrentDialogListItem(3)
                                                setVirtualKeyDown(0x1B, true)
                                                setVirtualKeyDown(0x1B, false)
                                            end
                                        end
                                    end)
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /diagnos id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "���������: /diagnos id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_invite(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 8 and mainIni.config.rank < 11 then
                    if arg:match("%d+") then
                        local id = tonumber(arg:match("%d+"))
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        invite = {
                                            "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                            "/me ������� " .. username .. " � ���� ������, �����" .. P1 .. " \"���������\".",
                                            "/invite " .. id .. ""
                                        }
                                        sendChatArray(invite, 2222)
                                        wait(300)
                                        sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} ����� � ��     {FF827B}[2]{FFFFFF} � ������ ����", -1)
                                        sampAddChatMessage(script_hint .. "{FF827B}[3]{FFFFFF} ����������   {FF827B}[4]{FFFFFF} �������� ��������", -1)
                                        choice = true
                                        while choice do
                                            wait(0)
                                            if isKeyJustPressed(0x31) then
                                                choice = false
                                                invite1 = {
                                                    "/do Online-���� ������ ������: \"" .. username .." � �� ���\".",
                                                    "� ���������, �� ��� �� ���������, ��� ��� �������� � ������ ������ ���."
                                                }
                                                sendChatArray(invite1, 2222)
                                                action = false
                                            end
                                            if isKeyJustPressed(0x32) then
                                                choice = false
                                                invite2 = {
                                                    "/do Online-���� ������ ������: \"� " .. username .." ���������\".",
                                                    "� ���������, �� ��� �� ���������, ��� ��� � ��� ���� ���������."
                                                }
                                                sendChatArray(invite2, 2222)
                                                action = false
                                            end
                                            if isKeyJustPressed(0x33) then
                                                choice = false
                                                invite3 = {
                                                    "/me ������" .. P1 .. " ����� ����� � ������� ��� " .. username .. ".",
                                                    "/me �������" .. P1 .. " ����� � ������� " .. username .. "."
                                                }
                                                sendChatArray(invite3, 2222)
                                                action = false
                                                wait(1000)
                                                sampSendChat("/invite " .. id)
                                            end
                                            if isKeyJustPressed(0x34) then
                                                sampAddChatMessage(script_hint .. "�� �������� �������� {FF827B}Invite{FFFFFF}.", -1)
                                                choice = false
                                                action = false
                                            end
                                        end
                                    else
                                        sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /invite id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /invite id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_division(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 8 and mainIni.config.rank < 11 then
                    if arg:match("%d+") then
                        local id = tonumber(arg:match("%d+"))
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        division = {
                                            "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                            "/me ��" .. P3 .." ��������� � ������ ���� ���������� " .. username .. " � ���� ������.",
                                            "/division " .. id .. ""
                                        }
                                        sendChatArray(division, 2222)
                                    else
                                        sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /division id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /division id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_uninvite(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 7 and mainIni.config.rank < 12 then
                    if arg:match("(%d+)%s+(.+)") then
                        local id = tonumber(arg:match("(%d+) "))
                        local reason = arg:match("%d+%s+(.+)")
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                action = true
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                uninvite = {
                                    "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                    "/me ���" .. P2 .. " ������ ���� ���������� " .. username .. "."
                                }
                                sendChatArray(uninvite, 2222)
                                if sampIsPlayerConnected(id) and username == sampGetPlayerNickname(id):gsub("_", "") then
                                    sampSendChat("/uninvite " .. id .. " " .. reason .. " " .. mainIni.config.tag)
                                else
                                    sampSendChat("/uninviteoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                                end
                                action = false
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /uninvite id �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /uninvite id �������.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_uninviteoff(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 7 and mainIni.config.rank < 12 then
                    if arg:match("(.+)%s+(.+)") then
                        local username = arg:match("(.+) "):gsub("_", " ")
                        local reason = arg:match(".+%s+(.+)")
                        if username == myNickname:gsub("_", " ") then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        else
                            action = true
                            uninvite = {
                                "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                "/me ���" .. P2 .. " ������ ���� ���������� " .. username .. "."
                            }
                            sendChatArray(uninvite, 2222)
                            sampSendChat("/uninviteoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                            action = false
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /uninviteoff ��� �������.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_fwarn(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 7 and mainIni.config.rank < 12 then
                    if arg:match("(%d+)%s+(.+)") then
                        local id = tonumber(arg:match("(%d+) "))
                        local reason = arg:match("%d+%s+(.+)")
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                action = true
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                fwarn = {
                                    "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                    "/me ��" .. P3 .. " ������� � ������ ���� ���������� " .. username .. "."
                                }
                                sendChatArray(fwarn, 2222)
                                if sampIsPlayerConnected(id) and username == sampGetPlayerNickname(id):gsub("_", " ") then
                                    sampSendChat("/fwarn " .. id .. " " .. reason .. " " .. mainIni.config.tag)
                                else
                                    sampSendChat("/fwarnoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                                end
                                action = false
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /fwarn id �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /fwarn id �������.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_fwarnoff(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 7 and mainIni.config.rank < 12 then
                    if arg:match("(.+)%s+(.+)") then
                        local username = arg:match("(.+) "):gsub("_", " ")
                        local reason = arg:match(".+%s+(.+)")
                        if username == myNickname:gsub("_", "") then
                            sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                        else
                            action = true
                            fwarn = {
                                "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                "/me ��" .. P3 .. " ������� � ������ ���� ���������� " .. username .. "."
                            }
                            sendChatArray(fwarn, 2222)
                            sampSendChat("/fwarnoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                            action = false
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /fwarnoff ��� �������.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_unfwarn(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 7 and mainIni.config.rank < 12 then
                    if arg:match("(%d+)%s+(.+)") then
                        local id = tonumber(arg:match("(%d+) "))
                        local reason = arg:match("%d+%s+(.+)")
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                action = true
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                unfwarn = {
                                    "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                    "/me ������" .. P1 .. " ������� �� ������� ���� ���������� " .. username .. "."
                                }
                                sendChatArray(unfwarn, 2222)
                                sampSendChat("/unfwarn " .. id .. " " .. reason .. " " .. mainIni.config.tag)
                                action = false
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /unfwarn id �������.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /unfwarn id �������.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_rang(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 8 and mainIni.config.rank < 11 then
                    if arg:match("%d+") then
                        local id = tonumber(arg:match("%d+"))
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampAddChatMessage(script_hint .. "�� �� ������ ������������ ��� ������� �� ����.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id)
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        rang = {
                                            "/me �������" .. P1 .. " ����� ������� ��� ���������� " .. username .. ".",
                                            "/me ������ ��������, ������" .. P1 .. " online-���� ������ �����������.",
                                            "/me ��" .. P3 .." ��������� � ������ ���� ���������� " .. username .. " � ���� ������."
                                        }
                                        sendChatArray(rang, 2222)
                                        action = false
                                        sampSendChat("/rang " .. id)
                                        wait(2000)
                                        choice = true
                                        sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} ������ ����� ����� {FF827B}[2]{FFFFFF} ���������")
                                        while choice do
                                            if isKeyJustPressed(0x31) then
                                                cmd_setskin(id)
                                            end
                                            if isKeyJustPressed(0x32) then
                                                choice = false
                                            end
                                        end
                                    else
                                        sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /rang id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /rang id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function cmd_setskin(arg)
    if mainIni.config.mainOrganization == "MH" then
        lua_thread.create(function()
            if not action then
                if mainIni.config.rank > 8 and mainIni.config.rank < 12 then
                    if arg:match("%d+") then
                        local id = tonumber(arg:match("%d+"))
                        if id >= 0 and id < 1000 then
                            if id == myId then
                                sampSendChat("/setskin " .. id)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id)
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        setskin = {
                                            "/do � ����� ����� � ����� ������.",
                                            "/me �������" .. P1 .. " ����� ���������� " .. username .. "."
                                        }
                                        sendChatArray(setskin, 2222)
                                        action = false
                                        sampSendChat("/setskin " .. id)
                                    else
                                        sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "����� ������� ������ �� ���.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "����� � id {FF827B}" .. id .. "{FFFFFF} �� ��������� � �������.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "���������: /setskin id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "���������: /setskin id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "��� ���������� ��� �������.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "������ ����������� ��������, ������� ����������.", -1)
            end
        end)
    end
end

function sampev.onServerMessage(color, text)
    if server then
        if text == "����� ���������� �� Diamond Role Play!" and serverIP == "51.83.207.242" then
            lua_thread.create(function()
                wait(1000)
                sampSendChat("/stats")
                getInfo = true
                sampev.onShowDialog()
                sampAddChatMessage(script_hint .. "��� ��������� ������ ������ " .. script_namem .." ����������� {FF827B}/mhelp{FFFFFF}.", -1)
                sampAddChatMessage(script_hint .. "����� lua " .. script_namem .." � {FF827B}Melanie Hate{FFFFFF}.", -1)
            end)
        end
    end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if server then
        if action then
            setVirtualKeyDown(0x1B, true)
            setVirtualKeyDown(0x1B, false)
        end
        if dialogId == 1 then
            local temp_pnumber = ""
            local temp_sex = ""
            local temp_mainOrganization = ""
            local temp_organization = ""
            local temp_position = ""
            local temp_rank = ""
            line_num = 0
            for line in text:gmatch("([^\n]*)\n?") do
                if line_num == 6 then temp_pnumber = line end
                if line_num == 17 then temp_sex = line end
                if line_num == 22 then temp_mainOrganization = line end
                if line_num == 23 then temp_organization = line end
                if line_num == 23 then temp_position = line end
                if line_num == 24 then temp_rank = line end
                line_num = line_num + 1
            end
            temp_pnumber = temp_pnumber:gsub("{FFFFFF}����� ��������: 		{0099ff}", "")
            if temp_sex:find("�������", 1, true) then temp_sex = "M" else temp_sex = "F" end
            if temp_mainOrganization:find("��������", 1, true) then temp_mainOrganization = "MH" else 
                temp_mainOrganization = "other"
                if getInfo then
                    sampAddChatMessage(script_hint .. "�� �� ��������� {FF827B}��{FFFFFF}, ������� " .. script_namem .. " ��� ��� ����������.", -1)
                end
            end
            if temp_mainOrganization ~= "other" then
                temp_position = temp_organization:gsub("{FFFFFF}������/���������: 		{0099ff}", ""):gsub(string.match(temp_organization, "��������...") .. " / ", "")
                temp_rank = temp_rank:gsub("0099ff", "FFFFFF"):match("%d+")
            else
                temp_position = "other"
                temp_rank = "other"
            end
            if temp_organization:find("��������", 1, true) then
                if string.match(temp_organization, "��������..."):gsub("�������� ", "") == "LS" then 
                    temp_organization = "LS"
                    temp_tag = "[LSHS]"
                elseif string.match(temp_organization, "��������..."):gsub("�������� ", "") == "SF" then
                    temp_organization = "SF"
                    temp_tag = "[SFHS]"
                elseif string.match(temp_organization, "��������..."):gsub("�������� ", "") == "LV" then
                    temp_organization = "LV"
                    temp_tag = "[LVHS]"
                else
                    temp_organization = "other"
                end
            end
            if getInfo then
                setVirtualKeyDown(0x0D, true)
                setVirtualKeyDown(0x0D, false)
                getInfo = false
            end
            mainIni.config.mainOrganization = temp_mainOrganization
            mainIni.config.organization = temp_organization
            mainIni.config.position = temp_position
            mainIni.config.sex = temp_sex
            mainIni.config.pnumber = temp_pnumber
            mainIni.config.rank = temp_rank
            inicfg.save(mainIni, directIni)
            mainIni = inicfg.load(nil, directIni)
        end
    end
end

function sampGetDistanceLocalPlayerToPlayerByPlayerId(playerId)
	local playerId = tonumber(playerId, 10)
	if not playerId then return end
	local res, han = sampGetCharHandleBySampPlayerId(playerId)
	if res then
		local x, y, z = getCharCoordinates(playerPed)
		local xx, yy, zz = getCharCoordinates(han)
		return true, getDistanceBetweenCoords3d(x, y, z, xx, yy, zz)
	end
	return false
end