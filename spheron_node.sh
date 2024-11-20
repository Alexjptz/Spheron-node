#!/bin/bash

tput reset
tput civis

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

exit_script() {
    show_red "Скрипт остановлен (Script stopped)"
        echo ""
        exit 0
}

incorrect_option () {
    echo ""
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo ""
    show_red "Invalid option. Please choose from the available options."
    echo ""
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_red "Ошибка (Fail)"
        echo ""
    fi
}

print_logo () {
    echo
    show_orange "   ______  __    __       ___       __  .__   __. " && sleep 0.2
    show_orange "  /      ||  |  |  |     /   \     |  | |  \ |  | " && sleep 0.2
    show_orange " |  ,----'|  |__|  |    /  ^  \    |  | |   \|  | " && sleep 0.2
    show_orange " |  |     |   __   |   /  /_\  \   |  | |  .    | " && sleep 0.2
    show_orange " |   ----.|  |  |  |  /  _____  \  |  | |  |\   | " && sleep 0.2
    show_orange "  \______||__|  |__| /__/     \__\ |__| |__| \__| " && sleep 0.2
    show_orange " .______        ___           _______. _______    " && sleep 0.2
    show_orange " |   _  \      /   \         /       ||   ____|   " && sleep 0.2
    show_orange " |  |_)  |    /  ^  \       |   (---- |  |__      " && sleep 0.2
    show_orange " |   _  <    /  /_\  \       \   \    |   __|     " && sleep 0.2
    show_orange " |  |_)  |  /  _____  \  .----)   |   |  |____    " && sleep 0.2
    show_orange " |______/  /__/     \__\ |_______/    |_______|   " && sleep 0.2
    echo
    sleep 1
}

install_or_update_docker() {
    process_notification "Ищем Docker (Looking for Docker)..."
    if which docker > /dev/null 2>&1; then
        show_green "Docker уже установлен (Docker is already installed)"
        echo
        # Try to update Docker
        process_notification "Обновляем Docker до последней версии (Updating Docker to the latest version)..."

        if sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
            sudo apt-get update &&
            sudo apt-get install -y docker-compose-plugin &&
            sudo apt-get install --only-upgrade docker-ce docker-ce-cli containerd.io docker-compose-plugin -y; then
            sleep 1
            echo -e "Обновление Docker (Docker update): \e[32mУспешно (Success)\e[0m"
            echo ""
        else
            echo -e "Обновление Docker (Docker update): \e[31мОшибка (Error)\e[0m"
            echo ""
        fi
    else
        # Install docker
        show_red "Docker не установлен (Docker not installed)"
        echo
        process_notification "\e[33mУстанавливаем Docker (Installing Docker)...\e[0m"

        if sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
        sudo apt-get update &&
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y; then
            sleep 1
            echo -e "Установка Docker (Docker installation): \e[32mУспешно (Success)\e[0m"
            echo
        else
            echo -e "Установка Docker (Docker installation): \e[31mОшибка (Error)\e[0m"
            echo
        fi
    fi
}

while true; do
    print_logo
    show_green "------ MAIN MENU ------ "
    echo "1. Подготовка (Preparation)"
    echo "2. Запуск/Остановка (Start/Stop)"
    echo "3. Логи (Logs)"
    echo "4. Выход (Exit)"
    echo
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            process_notification "Начинаем подготовку (Starting preparation)..."
            run_commands "cd $HOME && sudo apt update && sudo apt upgrade -y && sudo apt install mc nano"

            process_notification "Docker"
            install_or_update_docker

            echo
            show_green "--- ПОГОТОВКА ЗАЕРШЕНА. PREPARATION COMPLETED ---"
            echo
            ;;
        2)
            process_notification "Запускаем (Starting)..."
            run_commands "cd $HOME && chmod +x fizzup.sh && ./fizzup.sh"
            ;;
        3)
            process_notification "Запускаем логи (Stariting logs)"
            docker-compose -f ~/.spheron/fizz/docker-compose.yml logs -f
            ;;
        4)
            exit_script
            ;;
        *)
            incorrect_option
            ;;
    esac
done
