#!/bin/bash

# run_code_server.sh

# --- Configuration ---
# 🚨 기본 컨테이너 이름 및 이미지
CONTAINER_NAME="code-server"
IMAGE_NAME="codercom/code-server:latest"
VOLUME_NAME="code-server-data"
NETWORK_NAME="code-net"
# 🚨 Docker Compose 파일 이름 (사용자가 가지고 있다고 가정)
COMPOSE_FILE="docker-compose.yml"
# 🚨 Code Server 포트
HOST_PORT="8080"
CONTAINER_PORT="8080"

# --- Docker Compose Command Check ---
# 🚨 신/구 버전 Docker Compose 명령어를 확인하고 변수에 저장
DOCKER_COMPOSE_CMD=""
if command -v docker compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose" # 신버전
elif command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker-compose" # 구버전
fi

# --- Color Definitions ---
RESET='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'

# 기본 색상 (Standard Colors)
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[0;37m'
BLACK='\033[0;30m'

# 밝은 색상 (Bright/Bold Colors)
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_MAGENTA='\033[1;35m'

# 배경 색상 (Background Colors)
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'
BG_BLACK='\033[40m'
BG_GRAY='\033[100m'

# --- Utility Functions ---

# 🚨 code-server 실행에 필요한 Docker 환경 설정 (볼륨, 네트워크)
setup_docker_env() {
    echo -e "${CYAN}--- Setting up Docker Environment (Volume & Network) ---${RESET}"
    
    # 볼륨 생성 (이미 존재하면 경고 메시지 없이 넘어감)
    docker volume create "$VOLUME_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Volume '$VOLUME_NAME' created or already exists.${RESET}"
    else
        echo -e "${RED}❌ Failed to create volume '$VOLUME_NAME'.${RESET}"
        return 1
    fi

    # 네트워크 생성 (이미 존재하면 경고 메시지 없이 넘어감)
    docker network create "$NETWORK_NAME" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Network '$NETWORK_NAME' created or already exists.${RESET}"
    else
        echo -e "${RED}❌ Failed to create network '$NETWORK_NAME'.${RESET}"
        return 1
    fi
    return 0
}

# 🚨 실행 중인 code-server 컨테이너 정지 (삭제하지 않음)
stop_container_only() {
    echo -e "${YELLOW}--- Stopping '$CONTAINER_NAME' Container ---${RESET}"
    
    # 실행 중인 컨테이너만 정지
    if docker container inspect -f '{{.State.Running}}' "$CONTAINER_NAME" > /dev/null 2>&1; then
        echo -e "${YELLOW}Stopping container '$CONTAINER_NAME'...${RESET}"
        
        docker stop "$CONTAINER_NAME" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Container '$CONTAINER_NAME' successfully stopped.${RESET}"
        else
            echo -e "${RED}❌ Failed to stop container '$CONTAINER_NAME'.${RESET}"
            return 1
        fi
    else
        echo -e "${CYAN}ℹ️ Container '$CONTAINER_NAME' is not running.${RESET}"
    fi
    return 0
}

# 🚨 컨테이너 삭제 (down 시 사용)
remove_container_only() {
    echo -e "${YELLOW}--- Removing '$CONTAINER_NAME' Container ---${RESET}"
    
    # 컨테이너가 존재하면 (실행 중이든 정지 상태든) 삭제
    if docker container inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
        echo -e "${YELLOW}Force stopping and removing container '$CONTAINER_NAME'...${RESET}"
        
        docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Container '$CONTAINER_NAME' successfully removed.${RESET}"
        else
            echo -e "${RED}❌ Failed to remove container '$CONTAINER_NAME'.${RESET}"
            return 1
        fi
    else
        echo -e "${CYAN}ℹ️ Container '$CONTAINER_NAME' does not exist.${RESET}"
    fi
    return 0
}

# --- State Management Functions (start/stop/restart) ---

# 🚨 Docker CLI 시작 (정지된 컨테이너 재사용)
start_docker_cli() {
    echo -e "${BRIGHT_CYAN}--- Starting Code-Server with Docker CLI ---${RESET}"
    
    # 1. 환경 설정
    if ! setup_docker_env; then
        return 1
    fi

    # 2. 정지된 컨테이너가 있는지 확인하고 시작
    if docker container inspect -f '{{.State.Status}}' "$CONTAINER_NAME" 2>/dev/null | grep -q 'exited'; then
        echo -e "${CYAN}🔄 Restarting existing stopped container '$CONTAINER_NAME'...${RESET}"
        docker start "$CONTAINER_NAME"
    elif docker container inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -q 'true'; then
        echo -e "${YELLOW}⚠️ Container '$CONTAINER_NAME' is already running. Skipping start.${RESET}"
        return 0
    else
        # 3. 컨테이너가 없으면 새로 생성하도록 up 함수를 사용하도록 유도
        echo -e "${YELLOW}ℹ️ Container '$CONTAINER_NAME' does not exist. Use 'up cli' command to create it.${RESET}"
        return 1
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Code-Server Container Started Successfully.${RESET}"
        echo -e "${CYAN}🌐 Access URL: http://localhost:$HOST_PORT${RESET} (or ${CYAN}Server IP:$HOST_PORT${RESET})"
    else
        echo -e "${BG_RED}❌ Code-Server Container Start Failed.${RESET}"
        return 1
    fi
}

# 🚨 Docker Compose 시작 (정지된 서비스 재시작)
start_docker_compose() {
    echo -e "${BRIGHT_CYAN}--- Starting Code-Server with Docker Compose ---${RESET}"

    if [ -z "$DOCKER_COMPOSE_CMD" ]; then
        echo -e "${BG_RED}❌ Error: Docker Compose (docker compose or docker-compose) command not found.${RESET}"
        return 1
    fi
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo -e "${BG_RED}❌ Error: '$COMPOSE_FILE' not found. Cannot start compose project.${RESET}"
        return 1
    fi

    # compose start: 정지된 서비스만 시작 (새 컨테이너는 만들지 않음)
    echo -e "${CYAN}🔄 Starting existing stopped services using '$DOCKER_COMPOSE_CMD'...${RESET}"
    
    $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" start
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Code-Server via Docker Compose Started Successfully.${RESET}"
        echo -e "${CYAN}🌐 Access URL: http://localhost:$HOST_PORT${RESET} (or ${CYAN}Server IP:$HOST_PORT${RESET})${RESET}"
    else
        echo -e "${YELLOW}⚠️ Compose start failed or no stopped containers found. Use 'up compose' to create/run.${RESET}"
        return 1
    fi
}

# 🚨 실행 (메인 함수)
start() {
    TOOL=$1
    if [ "$TOOL" = "cli" ]; then
        start_docker_cli
    elif [ "$TOOL" = "compose" ]; then
        start_docker_compose
    else
        echo -e "${BG_RED}❌ Error: Please specify the tool: cli or compose (e.g., $0 start cli)${RESET}"
        help
        return 1
    fi
    
    START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\n-------------- [START] Code-Server Container Status Changed to Running at $START_TIME --------------\n"
}

# 🚨 중지 (컨테이너 정지만 수행)
stop() {
    echo -e "${BRIGHT_CYAN}--- Stopping Code-Server ---${RESET}"
    
    # 1. Docker Compose 방식으로 중지 시도 (stop)
    if [ -f "$COMPOSE_FILE" ] && [ -n "$DOCKER_COMPOSE_CMD" ]; then
        echo -e "${YELLOW}Attempting to stop using Docker Compose (stop) via '$DOCKER_COMPOSE_CMD'...${RESET}"
        $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" stop
        # Compose stop이 성공하면 (컨테이너가 존재했다면) 종료
        if [ $? -eq 0 ]; then
             echo -e "${GREEN}✅ Code-Server via Compose stopped.${RESET}"
             return 0
        fi
    fi

    # 2. CLI 방식으로 시도
    stop_container_only
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Code-Server via CLI stopped.${RESET}"
        return 0
    fi
    
    echo -e "${CYAN}☑️ No running code-server container found to stop.${RESET}"
}

# 🚨 재시작 (정지 -> 시작)
restart() {
    TOOL=$1
    echo -e "${BRIGHT_CYAN}--- Restarting Code-Server (Stop then Start) ---${RESET}"
    
    # [DEBUG] 로그: 재시작
    echo -e "${BLUE}[DEBUG] ⚙️ Restarting container...${RESET}"
    
    stop
    sleep 2 # 컨테이너가 완전히 종료되기를 기다림
    start "$TOOL"
}

# --- Lifecycle Management Functions (down/up/recreate) ---

# 🚨 컨테이너 및 리소스 완전히 삭제
down() {
    TOOL=$1
    echo -e "${BRIGHT_RED}--- Tearing Down Code-Server (Container Removal) ---${RESET}"
    
    if [ "$TOOL" = "compose" ]; then
        if [ -z "$DOCKER_COMPOSE_CMD" ]; then
            echo -e "${BG_RED}❌ Error: Docker Compose command not found.${RESET}"
            return 1
        fi
        if [ ! -f "$COMPOSE_FILE" ]; then
            echo -e "${BG_RED}❌ Error: '$COMPOSE_FILE' not found. Cannot tear down compose project.${RESET}"
            return 1
        fi
        echo -e "${CYAN}🗑️ Removing Compose project containers and default network (down) via '$DOCKER_COMPOSE_CMD'...${RESET}"
        $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" down
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Compose project successfully removed.${RESET}"
        else
            echo -e "${BG_RED}❌ Docker Compose down failed.${RESET}"
            return 1
        fi
    elif [ "$TOOL" = "cli" ]; then
        remove_container_only
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ CLI container successfully removed.${RESET}"
        else
            echo -e "${BG_RED}❌ CLI container removal failed.${RESET}"
            return 1
        fi
    else
        echo -e "${BG_RED}❌ Error: Please specify the tool: cli or compose (e.g., $0 down cli)${RESET}"
        help
        return 1
    fi
}

# 🚨 컨테이너 생성 및 실행
up() {
    TOOL=$1
    echo -e "${BRIGHT_CYAN}--- Creating/Running Code-Server (Up) ---${RESET}"
    
    # 1. 환경 설정
    if ! setup_docker_env; then
        return 1
    fi

    if [ "$TOOL" = "compose" ]; then
        if [ -z "$DOCKER_COMPOSE_CMD" ]; then
            echo -e "${BG_RED}❌ Error: Docker Compose command not found.${RESET}"
            return 1
        fi
        if [ ! -f "$COMPOSE_FILE" ]; then
            echo -e "${BG_RED}❌ Error: '$COMPOSE_FILE' not found. Cannot run compose project.${RESET}"
            return 1
        fi
        
        # Compose up -d: 컨테이너가 없으면 생성 후 실행, 정지 상태면 시작
        echo -e "${CYAN}🚀 Running Compose project (up -d) via '$DOCKER_COMPOSE_CMD'...${RESET}"
        # [DEBUG] 로그: Compose up
        echo -e "${BLUE}[DEBUG] ✅ Running container via Compose (up -d)...${RESET}"

        $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" up -d
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Code-Server via Docker Compose Created/Started Successfully.${RESET}"
        else
            echo -e "${BG_RED}❌ Docker Compose up failed.${RESET}"
            return 1
        fi

    elif [ "$TOOL" = "cli" ]; then
        # CLI up: 기존 컨테이너가 있다면 삭제 후 새로 run (강제 생성)
        remove_container_only # 기존 컨테이너가 있으면 삭제
        
        echo -e "${CYAN}🚀 Running new container '$CONTAINER_NAME' in background (run -d)...${RESET}"
        # [DEBUG] 로그: CLI run
        echo -e "${BLUE}[DEBUG] ✅ Running container via CLI (run -d)...${RESET}"

        docker run -d \
            --name "$CONTAINER_NAME" \
            --restart unless-stopped \
            -p "$HOST_PORT":"$CONTAINER_PORT" \
            -v "$VOLUME_NAME":/home/coder/project \
            --network "$NETWORK_NAME" \
            "$IMAGE_NAME"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Code-Server Container Created/Started Successfully.${RESET}"
        else
            echo -e "${BG_RED}❌ Code-Server Container Run Failed.${RESET}"
            return 1
        fi

    else
        echo -e "${BG_RED}❌ Error: Please specify the tool: cli or compose (e.g., $0 up cli)${RESET}"
        help
        return 1
    fi
    
    echo -e "${CYAN}🌐 Access URL: http://localhost:$HOST_PORT${RESET} (or ${CYAN}Server IP:$HOST_PORT${RESET})"
    echo -e "${YELLOW}🔑 Initial Password: $CONTAINER_NAME 터미널에서 확인 (docker logs $CONTAINER_NAME)${RESET}"
}

# 🚨 컨테이너 재생성 (down 후 up)
recreate() {
    TOOL=$1
    echo -e "${BRIGHT_CYAN}--- Recreating Code-Server (Down then Up) ---${RESET}"
    
    # [DEBUG] 로그: 재생성
    echo -e "${BLUE}[DEBUG] ⚙️ Recreating container...${RESET}"
    
    # down 명령은 컨테이너를 삭제하고, up 명령은 새로 생성합니다.
    down "$TOOL"
    sleep 2 
    up "$TOOL"
}


# 🚨 상태 확인
status() {
    echo -e "${BRIGHT_CYAN}--- Code-Server Status ---${RESET}"
    
    # 1. Docker CLI Container 상태
    if docker ps -f name="$CONTAINER_NAME" --format '{{.ID}}' | grep -q .; then
        echo -e "${GREEN}✅ Container '$CONTAINER_NAME' is running.${RESET}"
        docker ps -f name="$CONTAINER_NAME"
    elif docker ps -a -f name="$CONTAINER_NAME" --format '{{.ID}}' | grep -q .; then
        echo -e "${YELLOW}⚠️ Container '$CONTAINER_NAME' exists but is stopped.${RESET}"
        docker ps -a -f name="$CONTAINER_NAME"
    else
        echo -e "${YELLOW}ℹ️ Container '$CONTAINER_NAME' does not exist.${RESET}"
    fi

    # 2. 접속 정보
    echo -e "\n${CYAN}🌐 Access URL:${RESET} ${MAGENTA}http://localhost:$HOST_PORT${RESET} (or Server IP:$HOST_PORT)"
    
    # 3. Docker Compose 상태 (선택 사항)
    if [ -f "$COMPOSE_FILE" ]; then
        echo -e "\n${CYAN}--- Docker Compose Project Status (using $DOCKER_COMPOSE_CMD) ---${RESET}"
        if [ -n "$DOCKER_COMPOSE_CMD" ]; then
            $DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" ps
        else
            echo -e "${RED}❌ Docker Compose command not found.${RESET}"
        fi
    fi
}

# 🚨 로그 확인
logs() {
    echo -e "${BRIGHT_CYAN}--- Code-Server Logs ---${RESET}"
    # tail 인자 확인 (기본은 -f)
    TAIL_FLAG="-f"
    if [ "$1" = "notail" ]; then
        TAIL_FLAG=""
    fi
    
    if docker ps -a -f name="$CONTAINER_NAME" --format '{{.ID}}' | grep -q .; then
        docker logs "$TAIL_FLAG" "$CONTAINER_NAME"
    else
        echo -e "${YELLOW}❌ Container '$CONTAINER_NAME' not found. Cannot show logs.${RESET}"
    fi
}

# 🚨 컨테이너 내부 셸 접속 (sh)
exec_sh() {
    echo -e "${BRIGHT_CYAN}--- Executing SHell in '$CONTAINER_NAME' ---${RESET}"
    
    if docker ps -f name="$CONTAINER_NAME" --format '{{.ID}}' | grep -q .; then
        echo -e "${YELLOW}Connecting to the container... (Type 'exit' to return)${RESET}"
        docker exec -it "$CONTAINER_NAME" /bin/sh # /bin/sh 사용
    else
        echo -e "${BG_RED}❌ Error: Container '$CONTAINER_NAME' is not running. Use 'start' or 'up' first.${RESET}"
    fi
}


# 🚨 사용법 안내
help() {
    echo
    echo -e "${CYAN}Usage: $0 <command> [tool] [--help]${RESET}"
    echo -e "Tool: ${MAGENTA}cli${RESET} (Docker CLI) | ${MAGENTA}compose${RESET} (Docker Compose)"
    echo -e "${YELLOW}--------------------------------------------------${RESET}"
    echo -e "${MAGENTA}:: State Management (Running/Stopped) ::${RESET}"
    echo -e "${YELLOW}  $0 start <cli|compose>    ${RESET} # 컨테이너 시작 (정지된 컨테이너만 재사용)"
    echo -e "${YELLOW}  $0 stop                   ${RESET} # 컨테이너 정지 (삭제하지 않음)"
    echo -e "${YELLOW}  $0 restart <cli|compose>  ${RESET} # 정지 후 시작"
    echo -e "${YELLOW}--------------------------------------------------${RESET}"
    echo -e "${MAGENTA}:: Lifecycle Management (Create/Delete) ::${RESET}"
    echo -e "${YELLOW}  $0 up <cli|compose>       ${RESET} # 컨테이너 생성 및 실행 (없으면 생성, 있으면 시작)"
    echo -e "${YELLOW}  $0 down <cli|compose>     ${RESET} # 컨테이너 정지 및 삭제"
    echo -e "${YELLOW}  $0 recreate <cli|compose> ${RESET} # 컨테이너 삭제 후 재생성"
    echo -e "${YELLOW}--------------------------------------------------${RESET}"
    echo -e "${MAGENTA}:: Utilities ::${RESET}"
    echo -e "${YELLOW}  $0 status                 ${RESET} # 현재 실행 상태 확인"
    echo -e "${YELLOW}  $0 logs [notail]          ${RESET} # 컨테이너 로그 확인"
    echo -e "${YELLOW}  $0 sh                     ${RESET} # 컨테이너 내부 셸 접속 (sh)"
    echo -e "${YELLOW}  $0 --help                 ${RESET} # 사용법 출력"
    echo
}

# --- Help Flag Check ---
# 인자의 위치에 상관없이 "--help"가 존재하면 help()를 호출하고 종료
for arg in "$@"; do
    if [ "$arg" = "--help" ]; then
        help
        exit 0
    fi
done

# --- Main Case Statement ---
# 첫 번째 인자(명령)를 기반으로 해당 함수를 호출합니다.
case "$1" in
    start) shift; start "$@" ;;
    stop) stop ;;
    restart) shift; restart "$@" ;;
    up) shift; up "$@" ;;
    down) shift; down "$@" ;;
    recreate) shift; recreate "$@" ;;
    status) status ;;
    logs) shift; logs "$@" ;;
    sh) exec_sh ;; # 함수 이름과 명령어 이름을 sh로 통일
    *) help ;;
esac
