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

local script_hint = "• {FFc800}[Подсказка]{FFFFFF} "
local script_namem = "{FF827B}Medical Assistant{FFFFFF}"
local server = false
local action = false
local choice = false
local getInfo = false
if mainIni.config.sex == "M" then P1 = "" elseif mainIni.config.sex == "F" then P1 = "а" end
if mainIni.config.sex == "M" then P2 = "" elseif mainIni.config.sex == "F" then P2 = "ла" end
if mainIni.config.sex == "M" then P3 = "ёс" elseif mainIni.config.sex == "F" then P3 = "есла" end
if mainIni.config.sex == "M" then P4 = "ёл" elseif mainIni.config.sex == "F" then P4 = "ла" end
if mainIni.config.sex == "M" then P5 = "ся" elseif mainIni.config.sex == "F" then P5 = "ась" end
if mainIni.config.sex == "M" then P6 = "ёл" elseif mainIni.config.sex == "F" then P6 = "ела" end

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
                            sampAddChatMessage(script_hint .. "Обнаружена новая версия lua " .. script_namem .. ". Запущено обновление.", -1)
                            downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
                                if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                    sampAddChatMessage(script_hint " Lua " .. script_namem .. " обновлён до последней версии.", -1)
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
                sampShowDialog(10000, script_namem .. " | Помощь", "{FF827B}/mhelp{FFFFFF} — Помощь.\n{FF827B}/mm{FFFFFF} — Меню.\n\n{FF827B}/heal{FFFFFF} — Выдать таблетку.\n{FF827B}/medcard{FFFFFF} — Выдать мед. карту.\n{FF827B}/vac{FFFFFF} — Сделать вакцинацию.\n{FF827B}/diagnos{FFFFFF} — Поставить диагноз.\n{FF827B}/procedure{FFFFFF} — Провести процедуру.\n{FF827B}/setsex{FFFFFF} — Провести операцию по смене пола.\n{FF827B}/possion{FFFFFF} — Закодировать игровой зависимости.\n\n{FF827B}/invite{FFFFFF} — Принять в организацию.\n{FF827B}/uninvite{FFFFFF} — Уволить из организации.\n{FF827B}/uninviteoff{FFFFFF} — Уволить из организации. {AAAAAA}(offline){FFFFFF}\n{FF827B}/fwarn{FFFFFF} — Выдать предупреждение.\n{FF827B}/fwarnoff{FFFFFF} — Выдать предупреждение. {AAAAAA}(offline){FFFFFF}\n{FF827B}/unfwarn{FFFFFF} — Снять предупреждение.\n{FF827B}/rang{FFFFFF} — Повысить или понизить в должности.\n{FF827B}/setskin{FFFFFF} — Выдать форму.\n\nЧтобы использовать команды без отыгровки, дублируйте последнюю букву команды.\n{AAAAAA}(/heal » /heall, /invite » /invitee  и т.д.){FFFFFF}\n\n{FF827B}•{FFFFFF} Автор lua — {FF827B}Melanie Hate{FFFFFF}.\n{FF827B}•{FFFFFF} Discord: {FF827B}JeEn.Off#2585{FFFFFF}.", "Закрыть", "", 0)
            else
                sampAddChatMessage(script_hint .. "Вы не сотрудник {FF827B}МЗ{FFFFFF}. Функции " .. script_namem .. " для Вас недоступны.", -1)
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
        sampAddChatMessage(script_hint .. "Lua " .. script_namem .. " работает только на Diamond RP Amber.", -1)
    end

    _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    myNickname = sampGetPlayerNickname(myId)

    while true do
        wait(0)
        if isKeyDown(0xA4) and isKeyJustPressed(0x31) then
            sampSendChat("Здравствуйте, я меня зовут " .. myNickname:gsub("_", " ") .. ". Что Вас беспокоит?")
        end
    end
end

function cmd_mm()
    sampShowDialog(10001, script_namem .. " | Меню", "{FF827B}[1]{FFFFFF} Симптомы {FF827B}[info]{FFFFFF}\n{FF827B}[2]{FFFFFF} Лекции", "Выбрать", "Закрыть", 2)
    while sampIsDialogActive() do
        wait(0)
        local result, button, list, input = sampHasDialogRespond(10001)
        if result and button == 0 then
        elseif result and list == 0 then
            sampShowDialog(10002, script_namem .. " | Симптомы", "{FFFFFF}Невроз: палата.\n{FF827B}•{FFFFFF} Периодическая паника. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Пациент иногда выкрикивает слова. {AAAAAA}(капсит){FFFFFF}\n\nБронхиальная Астма: палата.\n{FF827B}•{FFFFFF} Одышка при беге. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Одышка на месте. {AAAAAA}(уменьшение хп){FFFFFF}\n\nБронхит: палата.\n{FF827B}•{FFFFFF} Кашель. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Невнятная речь. {AAAAAA}(спутанные буквы в чате){FFFFFF}\n\nГастрит: палата.\n{FF827B}•{FFFFFF} Периодическая рвота. {AAAAAA}(анимация){FFFFFF}\n\nМирингит: палата.\n{FF827B}•{FFFFFF} Глухота. {AAAAAA}(не видит часть чата){FFFFFF}\n\nДерматит: палата.\n{FF827B}•{FFFFFF} Зуд. {AAAAAA}(анимация чесания){FFFFFF}\n\nГеморрой: палата.\n{FF827B}•{FFFFFF} Не может сесть в транспортное средство.\n\nГипогликемия: палата.\n{FF827B}•{FFFFFF} Не может работать на шахте, лесопилке, стройке.\n\nТуберкулёз: операционная №1.\n{FF827B}•{FFFFFF} Периодичный кашель. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Одышка. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Падение на ровном месте. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Кашель при беге.\n\nЦирроз печени: операционная №2.\n{FF827B}•{FFFFFF} Рвота. {AAAAAA}(анимация){FFFFFF}\n{FF827B}•{FFFFFF} Падение на землю. {AAAAAA}(уменьшение хп){FFFFFF}\n{FF827B}•{FFFFFF} Покраснение в глазах. {AAAAAA}(красный экран){FFFFFF}", "Закрыть", "", 0)
        elseif result and list == 1 then
            sampShowDialog(10003, script_namem .. " | Лекции", "{FF827B}[1]{FFFFFF} Интернатура\n{FF827B}[2]{FFFFFF} Выдача Мед. карт\n{FF827B}[3]{FFFFFF} Вакцинация и процедуры\n{FF827B}[4]{FFFFFF} Подготовка к вызову 9-1-1\n{FF827B}[5]{FFFFFF} Доклады в рацию\n{FF827B}[6]{FFFFFF} Выезд на дом\n{FF827B}[7]{FFFFFF} Устав MoH\n{FF827B}[8]{FFFFFF} Лекции в рацию", "Выбрать", "Закрыть", 2)
            lua_thread.create(function()
                while sampIsDialogActive() do
                    wait(0)
                    local result, button, list, input = sampHasDialogRespond(10003)
                    if result and button == 0 then
                    elseif result and list == 0 then
                        action = true
                        lecture1 = {
                            "Уважаемые студенты, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Интернатура 1-го курса».",
                            "Для продвижения по курсам, вам нужно сдать экзамен.",
                            "Экзамен состоит из 4-х частей: Устав МЗ, Клятва, ЦП, Речь врача.",
                            "С этим всем можно ознакомиться на официальном портале Федерации.",
                            "Экзамен сдаётся в устной форме Глав. врачу или Заместителю.",
                            "Сразу после удачного ответа, вы оставляете отчёт о прохождении курса...",
                            "...в документации Medical Academy.",
                            "После проверки отчёта, вы будите переведены на 2-й курс.",
                            "Всем спасибо за внимание."
                        }
                        sendChatArray(lecture1, 2222)
                        action = false
                    elseif result and list == 1 then
                        action = true
                        lecture2 = {
                            "Уважаемые студенты, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Выдача Мед. карт».",
                            "Терапевт является врачом-специалистом, который получил...",
                            "...подготовку по вопросам диагностики, лечение и...",
                            "..профилактики болезней.",
                            "Выдача мед. карт является одним из главных обязанностей...",
                            "...врача - Терапевта.",
                            "У Терапевта имеется личный, специализированный кабинет,",
                            "В котором проводиться полный мед. осмотр пациентов.",
                            "После полного спец. осмотра пациента, врач - Терапевт...",
                            "...обязан занести показания в мед. карту пациента, а также...",
                            "...поставить печать больницы.",
                            "При заполнении мед. карты Терапевт обязан попросить...",
                            "...паспорт у гражданина. В случае опечатки в паспорте...",
                            "...запрещено выдавать мед. карту.",
                            "Всем спасибо за внимание."
                        }
                        sendChatArray(lecture2, 2222)
                        action = false
                    elseif result and list == 2 then
                        action = true
                        lecture3 = {
                            "Уважаемые сотрудники, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Вакцинация и процедуры».",
                            "Специальность - врач, является ответственной и сложной профессией.",
                            "И всё что связанное с медициной должно делаться крайне аккуратно и...",
                            "...внимательно.",
                            "Также важным и ответственным деянием медиков являются...",
                            "...вакцины и процедуры, которые врач делает пациенту.",
                            "Существуют различные заболевания и к ним есть различные...",
                            "...методы лечения. Нужно знать, что к чему.",
                            "Поэтому вакцинацию и процедуры может делать только...",
                            "...специализированный врач - «Проктолог».",
                            "Или другой любой врач Хирургического отделения.",
                            "Всем спасибо за внимание."
                        }
                        sendChatArray(lecture3, 2222)
                        action = false
                    elseif result and list == 3 then
                        action = true
                        lecture4 = {
                            "Уважаемые студенты, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Подготовка к вызову 9-1-1».",
                            "Специальность «Врач» является ответственной и сложной профессией.",
                            "Особенно выделяют врачей-Фельдшеров или обслуживающий персонал КСП.",
                            "Это ещё куда более опасная, сложная и ответственная деятельность.",
                            "Обслуживающий персонал КСП всегда должен быть готов к вызову в...",
                            "...любое время. Ведь чья-то жизнь под угрозой и вам предстоит...",
                            "...её спасти.",
                            "У врача КСП, всегда должна быть с собой мед. сумка...",
                            "...и ящик КСП. Заполненная всем необходимым. Ситуации бывают...",
                            "...разные и их сложно предугадать, поэтому важно быть всегда...",
                            "...подготовленным!",
                            "Собирайте комплектующие заранее, до черезвычайных ситуаций.",
                            "Всем спасибо за внимание."
                        }
                        sendChatArray(lecture4, 2222)
                        action = false
                    elseif result and list == 4 then
                        action = true
                        lecture5 = {
                            "Уважаемые студенты, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Доклады в рацию».",
                            "Доклады - неотъемлемая часть вызовов 9-1-1.",
                            "Существуют некоторые правила, которых стоит придерживаться.",
                            "Каждый сотрудник Amber Emergency Medical Services экиперован рацией, с помощью...",
                            "...которой он может оповещать своих коллег о той или иной ситуации.",
                            "Первое и самое главное правило - это понять существенность вызова",
                            "/n Role Play вызов или Non RP.",
                            "Вызовы с непонятными причинами от неопознанных...",
                            "...личностей сотрудник обязан отклонять.",
                            "Сотрудники спец. отдела «Ambulance» имеют право...",
                            "...принимать любые вызовы с любой точки Федерации...",
                            "без задержки.",
                            "Оповещать в федеральную рацию следует в 3-х случаях.",
                            "1-й: выезд на вызов. 2-й: прибытие и оказание ПМП.",
                            "3-й: возвращение на ближайшую станцию или госпитализация больного.",
                            "Все доклады делаются в Федеральную рацию.",
                            "Всем спасибо за внимание.",
                        }
                        sendChatArray(lecture5, 2222)
                        action = false
                    elseif result and list == 5 then
                        action = true
                        lecture6 = {
                            "Уважаемые студенты, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Выезд на дом».",
                            "Пожилые люди тоже нуждаются в помощи, а также семьи...",
                            "...у которых имеется маленький ребёнок.",
                            "Сотрудники обязаны выезжать и на такой вид вызовов и...",
                            "...оказывать мед. помощь.",
                            "В случае необходимости, сотрудники обязаны доставить пострадавшего...",
                            "...в ближайшую мед-сан. часть, поддерживая cостояние пациента.",
                            "Всем спасибо за внимание."
                        }
                        sendChatArray(lecture6, 2222)
                        action = false
                    elseif result and list == 6 then
                        action = true
                        lecture7 = {
                            "Уважаемые студенты, минуточку внимания.",
                            "Сейчас я прочту лекцию на тему «Устав MoH».",
                            "Сейчас мы обсудим первый и основной пункт устава - «Общие положения».",
                            "Устав MoH является основным, официально-правовым документом.",
                            "Устав содержит 11 пунктов, в которых объясняются нормы дисциплины и не только.",
                            "Сотрудник обязан периодически просматривать устав, потому что в него могут...",
                            "...внести в любое время изменения.",
                            "За грубые нарушение устава сотрудник может быть уволен.",
                            "Так же, после принятия на работу по электронному заявлению,",
                            "Сотрудник или студент обязан пройти испытательный срок 7 дней.",
                            "Также меры наказания устанавливаются руководством.",
                            "И к завершению лекции хотел бы сказать, пункты устава вступают в силу с...",
                            "...момента их написания.",
                            "На этом у меня всё. Всем спасибо за внимание."
                        }
                        sendChatArray(lecture7, 2222)
                        action = false
                    elseif result and list == 7 then
                        sampShowDialog(10004, script_namem .. " | Лекции в рацию", "{FF827B}[1]{FFFFFF} Лечение строго в палате\n{FF827B}[2]{FFFFFF} Сон в неположенном месте\n{FF827B}[3]{FFFFFF} Незнание устава не осв. от ответственности\n{FF827B}[4]{FFFFFF} Казино вне рабочего дня\n{FF827B}[5]{FFFFFF} Прогул и игнор рации\n{FF827B}[6]{FFFFFF} Исп. служебного транспорта в личных целях\n{FF827B}[7]{FFFFFF} Субординация\n{FF827B}[8]{FFFFFF} Нарушение ценовой политики", "Выбрать", "Закрыть", 2)
                        lua_thread.create(function()
                            while sampIsDialogActive() do
                                wait(0)
                                local result, button, list, input = sampHasDialogRespond(10004)
                                if result and button == 0 then
                                elseif result and list == 0 then
                                    action = true
                                    lecture1 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что лечение пациентов происходит строго в палате!",
                                        "/r За нарушение данного правила, Вы можете быть наказаны!"
                                    }
                                    sendChatArray(lecture1, 2222)
                                    action = false
                                elseif result and list == 1 then
                                    action = true
                                    lecture2 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что за сон в неположенном месте вы можете получить выговор!",
                                        "/r Благодарю за внимание, не нарушайте!"
                                    }
                                    sendChatArray(lecture2, 2222)
                                    action = false
                                elseif result and list == 2 then
                                    action = true
                                    lecture3 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что незнание устава Министерства Здравоохранения..",
                                        "/r ..Не освобождает вас от ответственности!"
                                    }
                                    sendChatArray(lecture3, 2222)
                                    action = false
                                elseif result and list == 3 then
                                    action = true
                                    lecture4 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что играть в азартные игры можно только вне рабочее время!",
                                        "/r Спасибо за внимание, не нарушайте!"
                                    }
                                    sendChatArray(lecture4, 2222)
                                    action = false
                                elseif result and list == 4 then
                                    action = true
                                    lecture5 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что за прогул рабочего дня и игнорирование рации..",
                                        "/r ..вы можете получить наказание!"
                                    }
                                    sendChatArray(lecture5, 2222)
                                    action = false
                                elseif result and list == 5 then
                                    action = true
                                    lecture6 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что использование рабочего транспорта Клиники..",
                                        "/r В своих целях запрещено!"
                                    }
                                    sendChatArray(lecture6, 2222)
                                    action = false
                                elseif result and list == 6 then
                                    action = true
                                    lecture7 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что к пациентам нужно относиться уважительно и обращаться на \"Вы\".",
                                        "/r В случае нарушения данного правила, Вы можете получить наказание!"
                                    }
                                    sendChatArray(lecture7, 2222)
                                    action = false
                                elseif result and list == 7 then
                                    action = true
                                    lecture8 = {
                                        "/r Уважаемые сотрудники, прошу минуточку внимания!",
                                        "/r Хочу напомнить вам, что за нарушение Ценовой Политики вы можете понести наказание!",
                                        "/r Спасибо за внимание, не нарушайте!"
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    heal = {
                                        "/me осмотрел" .. P1 .. " пациента, и поставил" .. P1 .. " диагноз.",
                                        "/do Медицинская сумка на плече.",
                                        "/me достал" .. P1 .. " из медицинской сумки лекарство и бутылку воды.",
                                        "/me передал" .. P1 .. " бутылку воды и лекарство пациенту.",
                                        "Это обезболивающее. Если боль не прекратится - приходите в больницу для обследования."
                                    }
                                    sendChatArray(heal, 2222)
                                    if sampGetPlayerColor(id) == 2868859556 then sampSendChat("/heal " .. id .. " 1")
                                    elseif sampGetPlayerColor(id) == 301989887 then sampSendChat("/heal " .. id .. " 200")
                                    else sampSendChat("/heal " .. id .. " 300") end
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /heal id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /heal id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    sampSendChat("Передайте, пожалуйста, вашу ID-Card.")
                                    wait(2222)
                                    sampSendChat("/n /pass " .. myId)
                                    sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} Продолжить {FF827B}[2]{FFFFFF} NonRP ник {FF827B}[3]{FFFFFF} Отменить действие")
                                    choice = true
                                    while choice do
                                        wait(0)
                                        if isKeyJustPressed(0x31) then
                                            action = true
                                            medcard = {
                                                "/do На шее весит стетофонендоскоп.",
                                                "/me сняв стетофонендоскоп с шеи, вставил" .. P1 .. " оливы стетофонендоскопа в уши.",
                                                "/me водя головкой звукопровода по груди, провел" .. P1 .. " аускультацию сердца и лёгких.",
                                                "/me сняв стетофонендоскоп, повесил" .. P1 .. " его на шею.",
                                                "/do Медицинская карта лежит на столе.",
                                                "/me взял" .. P1 .. " медицинскую карту со стола.",
                                                "/do На столе лежит ручка.",
                                                "/me взял" .. P1 .. " ручку со стола.",
                                                "/me поставил" .. P1 .. " галочку на против строки \"Здоров\".",
                                                "/me поставил" .. P1 .. " подпись в графе \"Подпись врача\".",
                                                "/me положив ручку на стол, взял" .. P1 .. " со стола печать \"Ministry of Health\".",
                                                "/me поставил" .. P1 .. " печать \"Ministry of Health\".",
                                                "/me передал" .. P1 .. " медицинскую карту пациенту.",
                                                "/medcard " .. id .. ""
                                            }
                                            sendChatArray(medcard, 2222)
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x32) then
                                            sendchat("Извините, я не могу выдать Вам мед. карту, у Вас опечатка в паспорте.")
                                            wait(2222)
                                            sendchat("/n /mn ? Cмена нонРП ника. Правильный формат: \"Name_Surname\".")
                                            choice = false
                                        end
                                        if isKeyJustPressed(0x33) then
                                            sampAddChatMessage(script_hint .. "Вы отменили действие {FF827B}Выдача мед. карты{FFFFFF}.", -1)
                                            choice = false
                                        end
                                    end
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /medcard id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /medcard id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    vac = {
                                        "/do На столе лежат: шприцы, ампулы и лекарства.",
                                        "/me взял" .. P1 .. " шприц и ампулу со стола.",
                                        "/me проткнул" .. P1 .. " ампулу шприцом, наполняет шприц лекарством.",
                                        "/do Шприц наполнен лекарством из ампулы.",
                                        "/me левой рукой потер" .. P2 .. "  кожу на правой руке пациента.",
                                        "/me подн" .. P3 .. " шприц к руке, затем воткнул" .. P1 .. " иглу в вену."
                                    }
                                    sendChatArray(vac, 2222)
                                    wait(100)
                                    sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} Туберкулез  {FF827B}[2]{FFFFFF} Дерматит", -1)
                                    sampAddChatMessage(script_hint .. "{FF827B}[3]{FFFFFF} Бронхит       {FF827B}[4]{FFFFFF} Отменить действие", -1)
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
                                            sampAddChatMessage(script_hint .. "Вы отменили действие {FF827B}Вакцинация{FFFFFF}.", -1)
                                            choice = false
                                        end
                                    end
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /vac id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /vac id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    setsex = {
                                        "Ложимся голенькими на операционный стол!",
                                        "/me взявшись за ручку шкафа, открыл" .. P1 .. " её.",
                                        "/me достав из шкафа стерильные перчатки, надел" .. P1 .. " их.",
                                        "/me сняв маску для наркоза с держателя, одел" .. P1 .. " её на лицо пациента, затем включил" .. P1 .. " подачу наркоза.",
                                        "/do Пациент уснул под воздействием наркоза.",
                                        "/me взяв скальпель со стола, подош" .. P4 .. "  к пациенту.",
                                        "/me поднеся скальпель к паховой области, сделал" .. P1 .. "  надрез.",
                                        "/me убрав скальпель на стол, взял" .. P1 .. " медицинскую иглу и нити.",
                                        "/me аккуратными движениями наложил" .. P1 .. " швы на месте надреза.",
                                        "/me после операции, нажав на кнопку, отключил" .. P1 .. " подачу наркоза.",
                                        "/me снял" .. P1 .. " маску для наркоза с пациента.",
                                        "/do Пациент проснулся.",
                                        "/do Операция окончена.",
                                        "/setsex " .. id .. ""
                                    }
                                    sendChatArray(setsex, 2222)
                                    action = false
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /setsex id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /setsex id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        passion = {
                                            "/me открыл" .. P1 .. " медицинскую сумку, затем достал" .. P1 .. " оттуда упаковку со стерильными перчатками.",
                                            "/me вскрыл" .. P1 .. " упаковку, и натянул" .. P1 .. " перчатки на руки.",
                                            "/do На столе стоит колба с экспериментальным веществом.",
                                            "/me достал" .. P1 .. " из мед. сумки шприц и спиртовой раствор.",
                                            "/me собрав шприц, вставил" .. P1 .. " иглу в горлышко колбы.",
                                            "/me наполнив шприц, обработал" .. P1 .. " место укола.",
                                            "/me поднеся шприц к месту укола, ввел" .. P1 .. " препарат.",
                                            "/me достал" .. P1 .. " вату из мед.сумки, затем приложил" .. P1 .. " вату к месту укола."
                                        }
                                        sendChatArray(passion, 2222)
                                        wait(2222)
                                        sampSendChat("/passion " .. id ..  " " .. days ..  " " .. days*1000)
                                        action = false
                                    else
                                        sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /passion id дни {AAAAAA}(от 10 до 30){FFFFFF}.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /passion id дни {AAAAAA}(от 10 до 30){FFFFFF}.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /passion id дни {AAAAAA}(от 10 до 30){FFFFFF}.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    action = true
                                    diagnos = {
                                        "/me открыл" .. P1 .. " медицинскую сумку, после чего достал" .. P1 .. " из неё блокнот и ручку.",
                                        "/me внимательно выслушав симптомы больного, написал" .. P1 .. " диагноз и метод лечения.",
                                        "/todo Оплатите лечение в регистратуре.*оторвав листок и передавая его человеку напротив.",
                                        "/me кинул" .. P1 .. " блокнот и ручку в мед. сумку, после чего закрыл" .. P1 .. " её."
                                    }
                                    sendChatArray(diagnos, 2222)
                                    action = false
                                    wait(2222)
                                    sampSendChat("/diagnos " .. id)
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /diagnos id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /diagnos id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        elseif sampIsPlayerConnected(id) then
                            local username = sampGetPlayerNickname(id):gsub("_", " ")
                            local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                            if isint then
                                if rasst < 5 then
                                    sampShowDialog(10005, script_namem .. " | Процедуры", "{FF827B}[1]{FFFFFF} Невроз\n{FF827B}[2]{FFFFFF} Бронхиальная Астма\n{FF827B}[3]{FFFFFF} Бронхит\n{FF827B}[4]{FFFFFF} Гастрит\n{FF827B}[5]{FFFFFF} Мирингит\n{FF827B}[6]{FFFFFF} Дерматит\n{FF827B}[7]{FFFFFF} Геморрой\n{FF827B}[8]{FFFFFF} Гипогликемия\n{FF827B}[9]{FFFFFF} Туберкулёз\n{FF827B}[10]{FFFFFF} Цирроз печени", "Выбрать", "Закрыть", 2)
                                    lua_thread.create(function()
                                        while sampIsDialogActive() do
                                            wait(0)
                                            local result, button, list, input = sampHasDialogRespond(10005)
                                            if result and button == 0 then
                                            elseif result and list == 0 then
                                                action = true
                                                procedure1 = {
                                                    "Укладывайтесь, пожалуйста, на кровать.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, затем достал" .. P1 .." бланк рецепта.",
                                                    "/todo Сконцентрируйтесь на моем голосе и повторяйте действия, которые я говорю.*доставая ручку из кармана халата.",
                                                    "Закройте глаза и глубоко вдохните.",
                                                    "Подумайте о чем-то хорошем и попробуйте расслабиться.",
                                                    "/me начал" .. P1 .." выписывать рецепт на успокоительное.",
                                                    "/todo Представьте, что вы в полете, вы легки как перышко.*продолжая выписывать рецепт.",
                                                    "/me выписав рецепт, достал" .. P1 .." упаковку успокоительного из медицинской сумки.",
                                                    "Можете открыть глаза.",
                                                    "/todo Возьмите рецепт и упаковку таблеток, они вам помогут.*передавая рецепт и таблетки.",
                                                    "/me закрыл" .. P1 .." медицинскую сумку."
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
                                                    "Присаживайтесь, пожалуйста, на кровать.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, затем достал" .. P1 .." ингалятор с дозатором.",
                                                    "/me встряхнул" .. P1 .." ингалятор, передав его пациенту.",
                                                    "Держите ингалятор вертикально, безымянный палец поможет Вам освободить лекарство из ингалятора.",
                                                    "Держите мундштук ингалятора возле рта и глубоко выдыхайте.",
                                                    "Поместите мундштук в рот, крепко захватив его губами, поднимите подбородок слегка вверх.",
                                                    "Когда Вы глубоко и равномерно вдыхаете, нажмите канистру, чтобы освободить дозу лекарства.",
                                                    "Затем вдохните долго и глубоко, чтобы лекарство поступило глубоко в легкие.",
                                                    "Удалите мундштук изо рта, закройте рот и задержите на 10 секунд дыхание.",
                                                    "Выдыхайте через нос и при необходимости повторите процедуру.",
                                                    "/todo Сейчас вам станет легче, ингалятор можете оставить себе, используйте, если приступы повторятся.*закрывая сумку."
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
                                                    "Раздевайтесь по пояс и укладывайтесь, пожалуйста, на живот.",
                                                    "/me открыл" .. P1 .." тумбочку, достал" .. P1 .." упаковку с горчичниками, после чего положил" .. P1 .." её на тумбочку.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, достал" .. P1 .." оттуда упаковку со стерильными перчатками.",
                                                    "/me вскрыл" .. P1 .." упаковку и натянул" .. P1 .." перчатки на руки.",
                                                    "/do На тумбочке стоит заранее подготовленный тазик с горячей водой.",
                                                    "/me вскрыл" .. P1 .." упаковку с горчичниками, затем обмакнул" .. P1 .." их в тазик.",
                                                    "/me поместил" .. P1 .." набухший горчичник в области грудной клетки пациента.",
                                                    "/do У ног пациента лежит чистое махровое полотенце.",
                                                    "/me взял" .. P1 .." махровое полотенце, после чего сложил" .. P1 .." его в два слоя, затем поместил" .. P1 .." полотенце на горчичник.",
                                                    "/todo Через 5 минут процедура будет закончена.*снимая перчатки и устанавливая таймер на своих часах."
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
                                                    "Раздевайтесь по пояс и укладывайтесь, пожалуйста, на спину",
                                                    "/me открыл" .. P1 .." медицинскую сумку, достал" .. P1 .." оттуда упаковку со стерильными перчатками.",
                                                    "/me вскрыл" .. P1 .." упаковку, затем натянул" .. P1 .." перчатки на руки.",
                                                    "/me открыл" .. P1 .." тумбочку, и достал" .. P1 .." оттуда замотанный эндоскоп.",
                                                    "/todo Открывайте рот.*разматывая эндоскоп",
                                                    "/me подсоединил" .. P1 .." эндоскоп к монитору.",
                                                    "/me достал" .. P1 .." из кейса специальный гель, после чего нан" .. P3 .." его на кончик эндоскопа.",
                                                    "/todo Сделайте глоток.*поместив эндоскоп в пищевод пациента.",
                                                    "/me с помощью окуляра оценил" .. P1 .." состояние слизистой оболочки.",
                                                    "/me обратил" .. P1 .." внимание на монитор.",
                                                    "/do На мониторе показалась слизистая.",
                                                    "/todo Вам следует принимать антибиотики.*переместив кончик эндоскопа."
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
                                                    "Укладывайтесь, пожалуйста, на кровать.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, достал" .. P1 .." оттуда упаковку со стерильными перчатками.",
                                                    "/me вскрыл" .. P1 .." упаковку, затем натянул" .. P1 .." перчатки на руки.",
                                                    "/todo Ложитесь на правый бок.*доставая из сумки ушные капли.",
                                                    "/me достав из нижнего кармана флакон с ушными каплями, повернул" .. P5 .." к пациенту.",
                                                    "/me осмотрел" .. P1 .." ухо пациента.",
                                                    "/do Флакон с ушными каплями в руке.",
                                                    "/me вскрыл" .. P1 .." крышку ушных капель, затем открыл" .. P1 .." флакон.",
                                                    "/me наклонившись к уху пациента, опустил" .. P1 .." кончик флакона, после чего пара капель попали внутрь.",
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
                                                    "Укладывайтесь, пожалуйста, на кровать.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, достал" .. P1 .." оттуда упаковку со стерильными перчатками.",
                                                    "/me вскрыл" .. P1 .." упаковку, затем натянул" .. P1 .." перчатки на руки.",
                                                    "/me начал" .. P1 .." осматривать тело пациента.",
                                                    "/me задрал" .. P1 .." верхнюю одежду пациента.",
                                                    "/me заметил" .. P1 .." воспаление красного цвета в области живота.",
                                                    "/me достал" .. P1 .." из кейса нужную мазь, затем открыл" .. P1 .." крышку, и выдавил" .. P1 .." смесь на ладонь.",
                                                    "/me стал" .. P1 .." натирать мазь по всей области живота.",
                                                    "/todo Повернитесь на бок.*задирая кофту пациента выше.",
                                                    "/me заметив повреждение в области спины, выдавил" .. P1 .." мазь, затем стал" .. P1 .." размазывать по спине.",
                                                    "/todo Полежите несколько минут.*снимая перчатки и выкидывая их в урну."
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
                                                    "Укладывайтесь, пожалуйста, на бок и спустите штаны.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, достал" .. P1 .." оттуда упаковку со стерильными перчатками.",
                                                    "/me вскрыл" .. P1 .." упаковку, затем натянул" .. P1 .." перчатки на руки.",
                                                    "/me достал" .. P1 .." из медицинской сумки упаковку белого цвета.",
                                                    "/me раскрыв упаковку, взял" .. P1 .." одну свечу в руку.",
                                                    "/do Свеча в руке.",
                                                    "/me быстро и легко вв" .. P6 .." свечу в прямую кишку.",
                                                    "/todo Лежите до полного растворения свечи.*снимая перчатки и выкидывая их в урну."
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
                                                    "Укладывайтесь, пожалуйста, на живот.",
                                                    "/me открыл" .. P1 .." медицинскую сумку, достал" .. P1 .." оттуда упаковку со стерильными перчатками и масло для рук.",
                                                    "/me вскрыл" .. P1 .." упаковку, затем натянул" .. P1 .." перчатки на руки.",
                                                    "/me открыв крышку флакона, слегка надавил" .. P1 ..", после чего содержимое флакона оказалось на ладони.",
                                                    "/me начав растирать смесь руками.",
                                                    "/me приступил" .. P1 .." массажировать область шейных позвонков.",
                                                    "/me растирая смесь руками по всей спине, переш" .. P4 .." к массажу плечевых суставов.",
                                                    "/todo Лежите до полного впитывания.*доставая из мед. сумки сусли.",
                                                    "/todo Одна таблетка как одна чайная ложка сахара.*протягивая пачку человеку напротив."
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
                                                    "/me достал" .. P1 .." из мед.сумки шприц, ампулу с препаратом и спиртованную вату.",
                                                    "/me собрав шприц, вставил" .. P1 .." иглу в горлышко ампулы.",
                                                    "/me наполнив шприц, обработал" .. P1 .." место укола.",
                                                    "/me поднеся шприц к месту укола, вв" .. P6 .." препарат и приложил" .. P1 .." вату.",
                                                    "Придерживайте вату пару минут."
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
                                                    "/do Спиртовой раствор лежит в мед. сумке.",
                                                    "/me достав ёмкость с спиртовым раствором, открыл" .. P1 .." её.",
                                                    "/me намазал" .. P1 .." спиртовой раствор на руки.",
                                                    "/me закрыв ёмкость с спиртовым раствором, положил" .. P1 .." её в медицинскую сумку.",
                                                    "/me достал" .. P1 .." упаковку с хирургическими перчатками из мед.сумки.",
                                                    "/me вскрыл" .. P1 .." упаковку, натянул перчатки на руки.",
                                                    "/me cхватив застёжку медицинской сумки, потянул" .. P1 .." её на себя.",
                                                    "/do Медицинская сумка закрыта.",
                                                    "/me оттянул" .. P1 .." трубку от аппарата жизнеобеспечения.",
                                                    "/me взял" .. P1 .." со стола стерильную маску, затем присоединил" .. P1 .." её к трубке.",
                                                    "/me подставил" .. P1 .." маску к носогубной области пациента.",
                                                    "/me включил" .. P1 .." кнопку подачи кислорода.",
                                                    "/do Подача кислорода начата.",
                                                    "/do Шприц с наркозом на столе.",
                                                    "/me взял" .. P1 .." шприц, после чего вколол" .. P1 .." внутривенно наркоз.",
                                                    "/do Наркоз подействовал.",
                                                    "/me взял" .. P1 .." стерильные инструменты в руки.",
                                                    "/me обвёл" .. P1 .." место оперирования, вскоре сделал" .. P1 .." два надреза в области ниже.",
                                                    "/me аккуратно закрепил" .. P1 .." повреждённую область щипцами.",
                                                    "/me принялся обрабатывать стенки сосудов.",
                                                    "/me изъял" .. P1 .." поврежденный орган, после чего перен" .. P3 .." его в утку.",
                                                    "/me после чего накрыл" .. P1 .." кожу салфеткой.",
                                                    "/me вернул" .. P5 .." к пациенту.",
                                                    "/me взяв в руки ножницы, вырезал" .. P1 .." из салфетки квадрат.",
                                                    "/me подош" .. P4 .." к холодильнику, и открыл" .. P1 .." дверь.",
                                                    "/do На полке стоял контейнер с трансплантируемым органом.",
                                                    "/me взял" .. P1 .." контейнер в руки, закрыв дверь холодильника, подош" .. P4 .." к операционному столу.",
                                                    "/me аккуратно схватив орган в руки, приступил" .. P1 .." к трансплантации печени пациента.",
                                                    "/do На столе подготовлена нить и хирургическая игла.",
                                                    "/me приступил" .. P1 .." к зашиванию оперируемой зоны.",
                                                    "/do Спустя некоторое время операция была завершена успешно и пациент пришел в себя.",
                                                    "/me отставил" .. P1 .." мед. инструменты на стойке.",
                                                    "/me снял" .. P1 .." кислородную маску с пациента.",
                                                    "/me отключил" .. P1 .." аппарат подачи кислорода."
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
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /diagnos id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Правильно: /diagnos id.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        invite = {
                                            "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                            "/me добавив " .. username .. " в базу данных, нажал" .. P1 .. " \"Сохранить\".",
                                            "/invite " .. id .. ""
                                        }
                                        sendChatArray(invite, 2222)
                                        wait(300)
                                        sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} Игрок в ЧС     {FF827B}[2]{FFFFFF} У игрока варн", -1)
                                        sampAddChatMessage(script_hint .. "{FF827B}[3]{FFFFFF} Продолжить   {FF827B}[4]{FFFFFF} Отменить действие", -1)
                                        choice = true
                                        while choice do
                                            wait(0)
                                            if isKeyJustPressed(0x31) then
                                                choice = false
                                                invite1 = {
                                                    "/do Online-база выдала ошибку: \"" .. username .." в ЧС СМИ\".",
                                                    "К сожалению, Вы нам не подходите, так как состоите в черном списке СМИ."
                                                }
                                                sendChatArray(invite1, 2222)
                                                action = false
                                            end
                                            if isKeyJustPressed(0x32) then
                                                choice = false
                                                invite2 = {
                                                    "/do Online-база выдала ошибку: \"У " .. username .." судимость\".",
                                                    "К сожалению, Вы нам не подходите, так как у вас есть судимость."
                                                }
                                                sendChatArray(invite2, 2222)
                                                action = false
                                            end
                                            if isKeyJustPressed(0x33) then
                                                choice = false
                                                invite3 = {
                                                    "/me достал" .. P1 .. " новую форму и бейджик для " .. username .. ".",
                                                    "/me передал" .. P1 .. " форму и бейджик " .. username .. "."
                                                }
                                                sendChatArray(invite3, 2222)
                                                action = false
                                                wait(1000)
                                                sampSendChat("/invite " .. id)
                                            end
                                            if isKeyJustPressed(0x34) then
                                                sampAddChatMessage(script_hint .. "Вы отменили действие {FF827B}Invite{FFFFFF}.", -1)
                                                choice = false
                                                action = false
                                            end
                                        end
                                    else
                                        sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /invite id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /invite id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        division = {
                                            "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                            "/me вн" .. P3 .." изменение в личное дело сотрудника " .. username .. " в базу данных.",
                                            "/division " .. id .. ""
                                        }
                                        sendChatArray(division, 2222)
                                    else
                                        sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /division id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /division id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                action = true
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                uninvite = {
                                    "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                    "/me стёр" .. P2 .. " личное дело сотрудника " .. username .. "."
                                }
                                sendChatArray(uninvite, 2222)
                                if sampIsPlayerConnected(id) and username == sampGetPlayerNickname(id):gsub("_", "") then
                                    sampSendChat("/uninvite " .. id .. " " .. reason .. " " .. mainIni.config.tag)
                                else
                                    sampSendChat("/uninviteoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                                end
                                action = false
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /uninvite id причина.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /uninvite id причина.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        else
                            action = true
                            uninvite = {
                                "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                "/me стёр" .. P2 .. " личное дело сотрудника " .. username .. "."
                            }
                            sendChatArray(uninvite, 2222)
                            sampSendChat("/uninviteoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                            action = false
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /uninviteoff ник причина.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                action = true
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                fwarn = {
                                    "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                    "/me вн" .. P3 .. " выговор в личное дело сотрудника " .. username .. "."
                                }
                                sendChatArray(fwarn, 2222)
                                if sampIsPlayerConnected(id) and username == sampGetPlayerNickname(id):gsub("_", " ") then
                                    sampSendChat("/fwarn " .. id .. " " .. reason .. " " .. mainIni.config.tag)
                                else
                                    sampSendChat("/fwarnoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                                end
                                action = false
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /fwarn id причина.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /fwarn id причина.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                            sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                        else
                            action = true
                            fwarn = {
                                "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                "/me вн" .. P3 .. " выговор в личное дело сотрудника " .. username .. "."
                            }
                            sendChatArray(fwarn, 2222)
                            sampSendChat("/fwarnoff " .. username:gsub(" ", "_") .. " " .. reason .. " " .. mainIni.config.tag)
                            action = false
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /fwarnoff ник причина.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                action = true
                                local username = sampGetPlayerNickname(id):gsub("_", " ")
                                unfwarn = {
                                    "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                    "/me удалил" .. P1 .. " выговор из личного дело сотрудника " .. username .. "."
                                }
                                sendChatArray(unfwarn, 2222)
                                sampSendChat("/unfwarn " .. id .. " " .. reason .. " " .. mainIni.config.tag)
                                action = false
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /unfwarn id причина.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /unfwarn id причина.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                sampAddChatMessage(script_hint .. "Вы не можете использовать эту команду на себе.", -1)
                            elseif sampIsPlayerConnected(id) then
                                local username = sampGetPlayerNickname(id)
                                local isint, rasst = sampGetDistanceLocalPlayerToPlayerByPlayerId(id)
                                if isint then
                                    if rasst < 5 then
                                        action = true
                                        rang = {
                                            "/me передал" .. P1 .. " новый бейджик для сотрудника " .. username .. ".",
                                            "/me достав смартфон, открыл" .. P1 .. " online-базу данных организации.",
                                            "/me вн" .. P3 .." изменение в личное дело сотрудника " .. username .. " в базу данных."
                                        }
                                        sendChatArray(rang, 2222)
                                        action = false
                                        sampSendChat("/rang " .. id)
                                        wait(2000)
                                        choice = true
                                        sampAddChatMessage(script_hint .. "{FF827B}[1]{FFFFFF} Выдать новую форму {FF827B}[2]{FFFFFF} Закончить")
                                        while choice do
                                            if isKeyJustPressed(0x31) then
                                                cmd_setskin(id)
                                            end
                                            if isKeyJustPressed(0x32) then
                                                choice = false
                                            end
                                        end
                                    else
                                        sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /rang id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /rang id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
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
                                            "/do В руках пакет с новой формой.",
                                            "/me передал" .. P1 .. " пакет сотруднику " .. username .. "."
                                        }
                                        sendChatArray(setskin, 2222)
                                        action = false
                                        sampSendChat("/setskin " .. id)
                                    else
                                        sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                    end
                                else
                                    sampAddChatMessage(script_hint .. "Игрок слишком далеко от вас.", -1)
                                end
                            else
                                sampAddChatMessage(script_hint .. "Игрок с id {FF827B}" .. id .. "{FFFFFF} не подключён к серверу.", -1)
                            end
                        else
                            sampAddChatMessage(script_hint .. "Правильно: /setskin id.", -1)
                        end
                    else
                        sampAddChatMessage(script_hint .. "Правильно: /setskin id.", -1)
                    end
                else
                    sampAddChatMessage(script_hint .. "Вам недоступна эта команда.", -1)
                end
            else
                sampAddChatMessage(script_hint .. "Сейчас выполняется действие, команда недоступна.", -1)
            end
        end)
    end
end

function sampev.onServerMessage(color, text)
    if server then
        if text == "Добро пожаловать на Diamond Role Play!" and serverIP == "51.83.207.242" then
            lua_thread.create(function()
                wait(1000)
                sampSendChat("/stats")
                getInfo = true
                sampev.onShowDialog()
                sampAddChatMessage(script_hint .. "Для просмотра списка команд " .. script_namem .." используйте {FF827B}/mhelp{FFFFFF}.", -1)
                sampAddChatMessage(script_hint .. "Автор lua " .. script_namem .." — {FF827B}Melanie Hate{FFFFFF}.", -1)
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
            temp_pnumber = temp_pnumber:gsub("{FFFFFF}Номер телефона: 		{0099ff}", "")
            if temp_sex:find("Мужской", 1, true) then temp_sex = "M" else temp_sex = "F" end
            if temp_mainOrganization:find("Минздрав", 1, true) then temp_mainOrganization = "MH" else 
                temp_mainOrganization = "other"
                if getInfo then
                    sampAddChatMessage(script_hint .. "Вы не сотрудник {FF827B}МЗ{FFFFFF}, функции " .. script_namem .. " для вас недоступны.", -1)
                end
            end
            if temp_mainOrganization ~= "other" then
                temp_position = temp_organization:gsub("{FFFFFF}Работа/Должность: 		{0099ff}", ""):gsub(string.match(temp_organization, "Больница...") .. " / ", "")
                temp_rank = temp_rank:gsub("0099ff", "FFFFFF"):match("%d+")
            else
                temp_position = "other"
                temp_rank = "other"
            end
            if temp_organization:find("Больница", 1, true) then
                if string.match(temp_organization, "Больница..."):gsub("Больница ", "") == "LS" then 
                    temp_organization = "LS"
                    temp_tag = "[LSHS]"
                elseif string.match(temp_organization, "Больница..."):gsub("Больница ", "") == "SF" then
                    temp_organization = "SF"
                    temp_tag = "[SFHS]"
                elseif string.match(temp_organization, "Больница..."):gsub("Больница ", "") == "LV" then
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