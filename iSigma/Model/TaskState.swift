//
//  TaskState.swift
//  iSigma
//
//  Created by Alex Delin on 07/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct TaskState: CachableProtocol {
    var serverId: Int
    var order: Int
    var name: String
    var isFinal: Bool
}

extension TaskState {
    init?(taskType: TaskType.Name, name: String) {
        let taskState = taskStates[taskType]?.first(where: { $0.name == name })
        if let taskState = taskState {
            self.serverId = taskState.serverId
            self.order = taskState.order
            self.name = taskState.name
            self.isFinal = taskState.isFinal
        } else {
            return nil
        }
    }
    init?(taskStateId id: Int) {
        let taskType = taskStates.first(where: { $0.value.contains(where: { $0.serverId == id }) })
        let taskState = taskType?.value.first(where: { $0.serverId == id })
        if let taskState = taskState {
            self.serverId = taskState.serverId
            self.order = taskState.order
            self.name = taskState.name
            self.isFinal = taskState.isFinal
        } else {
            return nil
        }
    }
}

let taskStates : [TaskType.Name : [TaskState]] = [
    .nse : [
        TaskState(serverId: 362, order: -2, name: "Уточняется у клиента", isFinal: false),
        TaskState(serverId: 361, order: -1, name: "Уточняется у автора", isFinal: false),
        TaskState(serverId: 347, order: 0, name: "Воспроизводится автором", isFinal: false),
        TaskState(serverId: 837, order: 1, name: "Воспроизводится в УТ", isFinal: false),
        TaskState(serverId: 1279, order: 2, name: "Уточняется в АСП", isFinal: false),
        TaskState(serverId: 349, order: 3, name: "Уточняется в УА", isFinal: false),
        TaskState(serverId: 396, order: 4, name: "На визе УР", isFinal: false),
        TaskState(serverId: 1176, order: 5, name: "Ожидание производства", isFinal: false),
        TaskState(serverId: 350, order: 6, name: "Решается", isFinal: false),
        TaskState(serverId: 1145, order: 7, name: "Инспекция кода", isFinal: false),
        TaskState(serverId: 354, order: 8, name: "Не решено", isFinal: false),
        TaskState(serverId: 351, order: 9, name: "Реализовано, но не доступно", isFinal: false),
        TaskState(serverId: 838, order: 10, name: "Без тестирования", isFinal: false),
        TaskState(serverId: 352, order: 11, name: "Тестируется", isFinal: false),
        TaskState(serverId: 451, order: 12, name: "Тестирование отложено", isFinal: false),
        TaskState(serverId: 353, order: 13, name: "Тестирование невозможно", isFinal: false),
        TaskState(serverId: 355, order: 14, name: "Успешно протестировано", isFinal: false),
        TaskState(serverId: 357, order: 15, name: "Выпущено", isFinal: false),
        TaskState(serverId: 1175, order: 16, name: "Тестируется клиентом", isFinal: false),
        TaskState(serverId: 360, order: 17, name: "Отказано", isFinal: true),
        TaskState(serverId: 358, order: 18, name: "Доступно", isFinal: true),
        TaskState(serverId: 359, order: 19, name: "Есть решение", isFinal: true)
    ],
    .requirement : [
        TaskState(serverId: 588, order: -2, name: "Уточняется у клиента", isFinal: false),
        TaskState(serverId: 587, order: -1, name: "Уточняется у автора", isFinal: false),
        TaskState(serverId: 569, order: 0, name: "Зарегистрировано", isFinal: false),
        TaskState(serverId: 716, order: 1, name: "Зарегистрировано(*)", isFinal: false),
        TaskState(serverId: 1251, order: 2, name: "МП: Визирование", isFinal: false),
        TaskState(serverId: 896, order: 3, name: "РП: Визирование", isFinal: false),
        TaskState(serverId: 738, order: 4, name: "Общий анализ", isFinal: false),
        TaskState(serverId: 938, order: 5, name: "УТ: Акцептование", isFinal: false),
        TaskState(serverId: 897, order: 6, name: "Подготовка концепции", isFinal: false),
        TaskState(serverId: 898, order: 7, name: "Утверждение концепции", isFinal: false),
        TaskState(serverId: 570, order: 8, name: "Оценка трудоемкости на анализ", isFinal: false),
        TaskState(serverId: 931, order: 9, name: "Консультация аналитика", isFinal: false),
        TaskState(serverId: 1222, order: 10, name: "Оценка трудоемкости обновления тестового стенда проекта", isFinal: false),
        TaskState(serverId: 571, order: 11, name: "Оценка трудоемкости на разработку", isFinal: false),
        TaskState(serverId: 1200, order: 12, name: "Оценка трудоемкости на тестирование развитием", isFinal: false),
        TaskState(serverId: 572, order: 13, name: "Оценка трудоемкости на тестирование", isFinal: false),
        TaskState(serverId: 573, order: 14, name: "РП: Акцептование", isFinal: false),
        TaskState(serverId: 1211, order: 15, name: "Оценка трудоемкости на внедрение", isFinal: false),
        TaskState(serverId: 901, order: 16, name: "МП: Акцептование", isFinal: false),
        TaskState(serverId: 590, order: 17, name: "Предварительное согласование с клиентом", isFinal: false),
        TaskState(serverId: 902, order: 18, name: "РП: Перепланирование", isFinal: false),
        TaskState(serverId: 574, order: 19, name: "Планируется", isFinal: false),
        TaskState(serverId: 900, order: 20, name: "РП: Ожидание планирования", isFinal: false),
        TaskState(serverId: 899, order: 21, name: "МП: Ожидание контракта", isFinal: false),
        TaskState(serverId: 739, order: 22, name: "МП: Отложить реализацию", isFinal: false),
        TaskState(serverId: 740, order: 23, name: "Разработка UseCase", isFinal: false),
        TaskState(serverId: 695, order: 24, name: "Разработка постановки", isFinal: false),
        TaskState(serverId: 1295, order: 25, name: "Верификация", isFinal: false),
        TaskState(serverId: 696, order: 26, name: "Утверждение постановки аналитиками", isFinal: false),
        TaskState(serverId: 577, order: 27, name: "Утверждение постановки в УР", isFinal: false),
        TaskState(serverId: 1189, order: 28, name: "Утверждение постановки тестировщиками", isFinal: false),
        TaskState(serverId: 566, order: 29, name: "Согласование постановки с клиентом", isFinal: false),
        TaskState(serverId: 578, order: 30, name: "Разработка архитектурного приложения", isFinal: false),
        TaskState(serverId: 996, order: 31, name: "Утверждение архитектурного приложения", isFinal: false),
        TaskState(serverId: 981, order: 32, name: "Ожидание производства", isFinal: false),
        TaskState(serverId: 1127, order: 33, name: "На согласовании", isFinal: false),
        TaskState(serverId: 579, order: 34, name: "В производстве", isFinal: false),
        TaskState(serverId: 1138, order: 35, name: "Инспекция кода", isFinal: false),
        TaskState(serverId: 1289, order: 36, name: "Оценка трудоемкости на доработку тест-плана", isFinal: false),
        TaskState(serverId: 1258, order: 37, name: "Доработка ТП", isFinal: false),
        TaskState(serverId: 580, order: 38, name: "Реализовано, но не доступно", isFinal: false),
        TaskState(serverId: 581, order: 39, name: "Верифицируется аналитиком", isFinal: false),
        TaskState(serverId: 1223, order: 40, name: "Обновление тестового стенда проекта", isFinal: false),
        TaskState(serverId: 1201, order: 41, name: "Тестирование развитием", isFinal: false),
        TaskState(serverId: 1259, order: 42, name: "Тестирование внедрением", isFinal: false),
        TaskState(serverId: 582, order: 43, name: "Тестируется", isFinal: false),
        TaskState(serverId: 567, order: 44, name: "Тестирование невозможно", isFinal: false),
        TaskState(serverId: 568, order: 45, name: "Тестирование завершено", isFinal: false),
        TaskState(serverId: 583, order: 46, name: "Успешно протестировано", isFinal: false),
        TaskState(serverId: 584, order: 47, name: "Выпущено", isFinal: false),
        TaskState(serverId: 1165, order: 48, name: "Тестируется клиентом", isFinal: false),
        TaskState(serverId: 1293, order: 49, name: "Приемка в стенд", isFinal: false),
        TaskState(serverId: 982, order: 50, name: "Отложено", isFinal: false),
        TaskState(serverId: 585, order: 51, name: "Доступно", isFinal: true),
        TaskState(serverId: 589, order: 52, name: "Отказано", isFinal: true),
        TaskState(serverId: 586, order: 53, name: "Есть решение", isFinal: true)
    ],
    .techRequirement : [
        TaskState(serverId: 427, order: 0, name: "В производстве", isFinal: false),
        TaskState(serverId: 429, order: 1, name: "Реализовано, но не доступно", isFinal: false),
        TaskState(serverId: 430, order: 2, name: "Верификация автором", isFinal: false),
        TaskState(serverId: 428, order: 3, name: "Отложено", isFinal: false),
        TaskState(serverId: 431, order: 4, name: "Доступно", isFinal: true),
        TaskState(serverId: 861, order: 5, name: "Отказано", isFinal: true)
    ],
    .sprintRequirement : [
        TaskState(serverId: 1474, order: -2, name: "Уточняется у клиента", isFinal: false),
        TaskState(serverId: 1383, order: -1, name: "Уточняется у автора", isFinal: false),
        TaskState(serverId: 1372, order: 0, name: "Зарегистрировано", isFinal: false),
        TaskState(serverId: 1373, order: 1, name: "Визирование", isFinal: false),
        TaskState(serverId: 1374, order: 2, name: "Подготовка концепции", isFinal: false),
        TaskState(serverId: 1375, order: 3, name: "Планируется", isFinal: false),
        TaskState(serverId: 1376, order: 4, name: "Производство", isFinal: false),
        TaskState(serverId: 1377, order: 5, name: "Готов к демо", isFinal: false),
        TaskState(serverId: 1378, order: 6, name: "Выпущено", isFinal: false),
        TaskState(serverId: 1381, order: 7, name: "Отложена", isFinal: false),
        TaskState(serverId: 1379, order: 8, name: "Доступно", isFinal: true),
        TaskState(serverId: 1380, order: 9, name: "Отказано", isFinal: true),
        TaskState(serverId: 1384, order: 10, name: "Есть решение", isFinal: true)
    ],
    .consultation : [
        TaskState(serverId: 1161, order: -1, name: "Уточняется у клиента", isFinal: false),
        TaskState(serverId: 1239, order: 0, name: "Уточняется у автора", isFinal: false),
        TaskState(serverId: 1160, order: 1, name: "Обращение в УА", isFinal: false),
        TaskState(serverId: 197, order: 2, name: "Работа завершена", isFinal: true),
        TaskState(serverId: 195, order: 3, name: "Претендует на включение в базу знаний", isFinal: false),
        TaskState(serverId: 196, order: 4, name: "Включена в базу знаний", isFinal: true)
    ]
]
