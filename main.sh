#!/bin/bash
clear
 # Script ရဲ့ ထိပ်ဆုံးမှာ ဒါလေးအရင်ထည့်ထားပါ (နာမည်ပြောင်းရန်)
AUTHOR="HCM" 

## ---------------------------
## Global Variables
## ---------------------------
# Color Palette
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Box Drawing Characters
BOX_HORIZ="━"
BOX_VERT="┃"
BOX_CORNER_TL="┏"
BOX_CORNER_TR="┓"
BOX_CORNER_BL="┗"
BOX_CORNER_BR="┛"

## ---------------------------
## Initial Checks
## ---------------------------

# Root check
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root!${NC}"
    exit 1
fi

## ---------------------------
## Display Functions
## ---------------------------

# Function to get system information
get_system_info() {
    OS=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    UPTIME=$(uptime -p | sed 's/up //')
    IPV4=$(hostname -I | awk '{print $1}')
    
    # Server RAM
    RAM_TOTAL=$(free -h | awk 'NR==2{print $2}')
    RAM_USED=$(free -h | awk 'NR==2{print $3}')
    RAM_AVAIL=$(free -h | awk 'NR==2{print $7}')
    
    # CPU Core Information
    CPU_CORES=$(nproc --all)
    CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d':' -f2 | sed 's/^ *//')
    
    # ISP and City Information
    if command -v curl &> /dev/null; then
        IP_INFO=$(curl -s ipinfo.io)
        ISP=$(echo "$IP_INFO" | grep '"org":' | cut -d'"' -f4)
        CITY=$(echo "$IP_INFO" | grep '"city":' | cut -d'"' -f4)
        COUNTRY=$(echo "$IP_INFO" | grep '"country":' | cut -d'"' -f4)
        
        # If any info is empty, set default
        [ -z "$ISP" ] && ISP="Unknown"
        [ -z "$CITY" ] && CITY="Unknown"
        [ -z "$COUNTRY" ] && COUNTRY="Unknown"
    else
        ISP="curl not installed"
        CITY="Unknown"
        COUNTRY="Unknown"
    fi
}

# Function to draw box with title and content
draw_box() {
    local width=56
    local title="$1"
    local color="$2"
    local content="$3"
    
    # Top border with title
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"
    
    # Title centered
    local title_len=${#title}
    local padding_left=$(( (width - title_len - 2) / 2 ))
    local padding_right=$(( width - title_len - padding_left - 2 ))
    
    echo -ne "${color}${BOX_VERT}"
    printf "%${padding_left}s" ""
    echo -ne "${WHITE}${title}"
    printf "%${padding_right}s" ""
    echo -e "${color}${BOX_VERT}${NC}"
    
    # Content
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            echo -e "${color}${BOX_VERT}${NC} ${line}${color}${NC}"
        else
            echo -e "${color}${BOX_VERT}${NC}"
        fi
    done <<< "$content"
    
    # Bottom border
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

# Function to draw simple box
draw_simple_box() {
    local width=56
    local content="$1"
    local color="$2"
    
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"
    
    while IFS= read -r line; do
        echo -e "${color}${BOX_VERT}${NC} ${line}${color}${NC}"
    done <<< "$content"
    
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

## ---------------------------
## Working Installation Functions
## ---------------------------


    system_update() {
    draw_simple_box "${GREEN}Fetching update script from GitHub...${NC}"
    
    # GitHub Raw Link ကို ဒီနေရာမှာ ထည့်ပါ
    curl -sSL https://raw.githubusercontent.com/Script-HCM/update/refs/heads/main/update.sh | bash
    
    draw_simple_box "${GREEN}GitHub Update Process Finished!${NC}"
}


clean_cache() {
    draw_simple_box "${GREEN}Cleaning system cache...${NC}"
    sudo apt clean
    sudo apt autoclean
    sync
    draw_simple_box "${GREEN}Cache cleaned!${NC}"
}


clean_cache() {
    draw_simple_box "${GREEN}Cleaning system cache...${NC}" $GREEN
    apt clean
    apt autoclean
    sync
    draw_simple_box "${GREEN}System cache cleaned!${NC}" $GREEN
}

check_disk() {
    draw_simple_box "${GREEN}Checking disk space...${NC}" $GREEN
    df -h
    echo -e "\n${YELLOW}Large directories:${NC}"
    du -sh /var/log/* 2>/dev/null | sort -hr | head -10
}

install_zivpn() {
    draw_simple_box "${YELLOW}Installing ZI-VPN...${NC}" $YELLOW
    if command -v wget &> /dev/null; then
        wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
        chmod +x zi.sh
        ./zi.sh
    else
        apt install wget -y
        wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
        chmod +x zi.sh
        ./zi.sh
    fi
}

uninstall_zivpn() {
    draw_simple_box "${YELLOW}Uninstalling ZI-VPN...${NC}" $YELLOW
    if command -v wget &> /dev/null; then
        wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
        chmod +x ziun.sh
        ./ziun.sh
    else
        apt install wget -y
        wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
        chmod +x ziun.sh
        ./ziun.sh
    fi
}

3x-ui() {
    draw_simple_box "${BLUE}Installing Network Optimizer...${NC}"
    if ! command -v wget &> /dev/null; then
        apt install wget -y
    fi

    # ဖိုင်ကို download ဆွဲမယ် (အဟောင်းရှိရင် အမြဲ overwrite လုပ်ဖို့ -O သုံးပါတယ်)
    wget -qO install.sh "https://raw.githubusercontent.com/Script-HCM/x-ui/refs/heads/main/install.sh"
    
    chmod +x install.sh
    ./install.sh

}

    Firewall_install() {
    draw_simple_box "${CYAN}Installing Firewall Script...${NC}"
    
    if command -v git &> /dev/null; then
        # ၁။ Folder အဟောင်းရှိရင် ဖျက်ပါ (Error မတက်အောင်)
        rm -rf firewall
        
        # ၂။ Clone လုပ်ပါ
        git clone https://github.com/Script-HCM/firewall.git
        
        # ၃။ Folder ထဲကို အရင်ဝင်ပါ (ဒီနေရာမှာ cd firewall လိုပဲ ရေးရပါမယ်)
        cd firewall
        
        # ၄။ ပြီးမှ file ကို permission ပေးပြီး run ပါ
        chmod +x ufw-setup.sh
        ./ufw-setup.sh
        
        # ၅။ မူလနေရာကို ပြန်ထွက်ပါ
        cd ..
    else
        apt install git -y
        # else ထဲမှာလည်း အပေါ်က အဆင့်တွေအတိုင်း ပြန်ရေးပေးပါ
    fi
}

install_darkssh() {
    draw_simple_box "${BLUE}Installing DARKSSH Manager...${NC}" $BLUE
    if command -v wget &> /dev/null; then
        wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
        chmod +x Dark
        ./Dark
    else
        apt install wget -y
        wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
        chmod +x Dark
        ./Dark
    fi
}

speed-update() {
    draw_simple_box "${BLUE}Installing Network Optimizer...${NC}"
    
    # wget ရှိမရှိ အရင်စစ်မယ်
    if ! command -v wget &> /dev/null; then
        apt install wget -y
    fi

    # ဖိုင်ကို download ဆွဲမယ် (အဟောင်းရှိရင် အမြဲ overwrite လုပ်ဖို့ -O သုံးပါတယ်)
    wget -qO optimize.sh "https://raw.githubusercontent.com/Script-HCM/speed-up/refs/heads/main/optimize.sh"
    
    # Permission ပေးပြီး Run မယ်
    chmod +x optimize.sh
    ./optimize.sh
    
    # Run ပြီးရင် file ကို ပြန်ဖျက်ချင်ရင် (Optional)
    # rm optimize.sh
}
    # Run ပြီးရင် file ကို ပြန်ဖျက်ချင်ရင် (Optional)
    # rm optimize.sh

reboot_vps() {
    draw_simple_box "${RED}Rebooting VPS...${NC}" $RED
    echo -e "${YELLOW}VPS will reboot in 5 seconds...${NC}"
    sleep 5
    reboot
}

check_vps_status() {
    draw_simple_box "${GREEN}Checking VPS Status...${NC}" $GREEN
    echo -e "${WHITE}CPU Usage:${NC} $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo -e "${WHITE}Memory Usage:${NC} $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')"
    echo -e "${WHITE}Disk Usage:${NC} $(df -h / | awk 'NR==2{print $5}')"
    echo -e "${WHITE}Uptime:${NC} $(uptime -p)"
    echo -e "${WHITE}Load Average:${NC} $(uptime | awk -F'load average:' '{print $2}')"
}

clean_vps_logs() {
    draw_simple_box "${YELLOW}Cleaning VPS Logs...${NC}" $YELLOW
    echo -e "${WHITE}Clearing system logs...${NC}"
    truncate -s 0 /var/log/syslog
    truncate -s 0 /var/log/auth.log
    truncate -s 0 /var/log/kern.log
    echo -e "${WHITE}Clearing journal logs...${NC}"
    journalctl --vacuum-time=1d
    echo -e "${WHITE}Clearing temporary files...${NC}"
    rm -rf /tmp/*
    rm -rf /var/tmp/*
    draw_simple_box "${GREEN}VPS logs cleaned successfully!${NC}" $GREEN
}

show_vpn_port_info() {
    draw_simple_box "${BLUE}VPN Port Information...${NC}" $BLUE
    echo -e "${WHITE}Active listening ports:${NC}"
    netstat -tulpn | grep LISTEN
    echo -e "\n${WHITE}Common VPN ports status:${NC}"
    for port in 80 443 8080 8443 22 53; do
        if netstat -tulpn | grep ":${port} " > /dev/null; then
            echo -e "Port ${port}: ${GREEN}OPEN${NC}"
        else
            echo -e "Port ${port}: ${RED}CLOSED${NC}"
        fi
    done
}

## ---------------------------
## Menu Display
## ---------------------------

display_header() {
    clear
    get_system_info
    
    # Main header
    draw_box "SERVER MANAGEMENT TOOLKIT" $CYAN ""
    
    # System info box
    local sysinfo=$(cat <<EOF
${WHITE} OS         : ${GREEN}${OS}${NC}
${WHITE} UPTIME     : ${GREEN}${UPTIME}${NC}
${WHITE} IPv4       : ${GREEN}${IPV4}${NC}
${WHITE} SERVER RAM : ${GREEN}${RAM_USED}/${RAM_TOTAL} (Avail: ${RAM_AVAIL})${NC}
${WHITE} CPU CORES  : ${GREEN}${CPU_CORES} Cores${NC}
${WHITE} ISP        : ${GREEN}${ISP}${NC}
${WHITE} LOCATION   : ${GREEN}${CITY}, ${COUNTRY}${NC}
EOF
)
    draw_simple_box "$sysinfo" $BLUE
    
    # Main menu
    local mainmenu=$(cat <<EOF

${WHITE}[01] • System Update            [05] • DARK SSH MANAGER${NC} 
${WHITE}[02] •Firewall install          [06] • ZI-VPN INSTALL${NC}   
${WHITE}[03] • 3X-UI                    [07] • ZI-VPN UNINSTALL${NC}
${WHITE}[04] • speed-update ${NC}                
EOF
)
    draw_box "MENU" $GREEN "$mainmenu"
    
    # Tools menu
    local toolsmenu=$(cat <<EOF
                          
${WHITE}[08] • CLEAN CACHE            [11] • SERVER BENCHMARK${NC} 
${WHITE}[09] • CHECK DISK SPACE       [12] • VPN PORT INFO${NC}
${WHITE}[10] • VPS STATUS             [13] • CLEAN VPS LOGS${NC}

${WHITE}[00] • EXIT                   [88] • REBOOT VPS${NC}
EOF
)
    draw_box "TOOLS" $PURPLE "$toolsmenu"
    
    # Footer
    local footer=$(cat <<EOF
${WHITE}• VERSION      : 8.9${NC}
${WHITE}• SCRIPT BY    : H C M \ 2.8 [🇲🇲]${NC}
${WHITE}• CONTACT OWNER  : t.me/akuma_edu${NC}
EOF
)
    draw_simple_box "$footer" $YELLOW
    
    # Bottom separator
    echo -e "${CYAN}●━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━●${NC}"
}

## ---------------------------
## Menu Handlers
## ---------------------------

handle_main_menu() {
    case $1 in
        1) system_update ;;
        2) Firewall_install ;;
        3) 3x-ui ;;
        4) speed-update ;;
        5) install_darkssh ;;
        6) install_zivpn ;
        7) uninstall_zivpn ;;
        
        *) 
            draw_simple_box "${RED}Invalid Option in Main Menu!${NC}" $RED
            return 1 
            ;;
    esac
    return 0
}

handle_tools_menu() {
    case $1 in
        8) clean_cache ;;
        9) check_disk ;;
        10) check_vps_status ;;
        11) run_benchmark ;;
        12) show_vpn_port_info ;;
        13) clean_vps_logs ;;
        88) reboot_vps ;;
        *) 
            draw_simple_box "${RED}Invalid Option in Tools Menu!${NC}" $RED
            return 1 
            ;;
    esac
    return 0
}

install_option() {
    local choice="$1"
    case $choice in
        00|0)
            draw_simple_box "${GREEN}Thank you for using CHANNEL 404 TUNNEL!${NC}" $GREEN
            exit 0
            ;;
        1|2|3|4|5|6|7|8|9|10|11)
            handle_main_menu "$choice"
            ;;
        12|13|14|15|16|17|18|88)
            handle_tools_menu "$choice"
            ;;
        *)
            draw_simple_box "${RED}Invalid Option! Please select 0-18 or 88${NC}" $RED
            ;;
    esac
}

## ---------------------------
## Main Program
## ---------------------------

while true; do
    display_header
    
    echo -en "${GREEN} Select menu : ${NC}"
    read -r user_input
    
    # Input validation
    if [[ ! "$user_input" =~ ^[0-9]+$ ]]; then
        draw_simple_box "${RED}Please enter numbers only!${NC}" $RED
        echo -e "\n${YELLOW}Press any key to continue...${NC}"
        read -n 1 -s -r
        continue
    fi
    
    install_option "$user_input"
    
    echo -e "\n${YELLOW}Press any key to continue...${NC}"
    read -n 1 -s -r
done
