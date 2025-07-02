#!/bin/bash

# Проверяем, что находимся в git-репозитории
if [ ! -d .git ]; then
    echo "Ошибка: это не git-репозиторий!"
    exit 1
fi

# Начальная и конечная даты
start_date="2024-06-01"
end_date="2025-06-30"

# Преобразуем даты в секунды с начала эпохи
start_sec=$(date -d "$start_date" +%s)
end_sec=$(date -d "$end_date" +%s)

# Перебираем каждый день в диапазоне
for (( current_sec=start_sec; current_sec<=end_sec; current_sec+=86400 )); do
    # Преобразуем секунды обратно в дату
    current_date=$(date -d @"$current_sec" +"%Y-%m-%d %H:%M:%S")
    
    # Создаем или изменяем файл
    echo "Commit for $current_date" > daily_commits.txt
    
    # Добавляем файл в git
    git add daily_commits.txt
    
    # Делаем коммит с указанной датой
    GIT_AUTHOR_DATE="$current_date" GIT_COMMITTER_DATE="$current_date" \
    git commit -m "Daily commit for $current_date"
    
    echo "Создан коммит за $current_date"
done

# Пушим изменения в удаленный репозиторий (если нужно)
echo "Хотите отправить изменения в удаленный репозиторий? (y/n)"
read -r answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    git push
    echo "Изменения отправлены в удаленный репозиторий"
fi