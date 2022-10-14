fx_version 'cerulean'
game 'gta5'

author 'Cadburry#7547'
description 'Playerlist for QBCore FiveM'
version '0.4'

files {
    'nui/*'
}

ui_page 'nui/index.html'

shared_script 'scripts/config.lua'
client_script 'scripts/client.lua'
server_script 'scripts/server.lua'
server_script 'version.lua'

lua54 'yes'

escrow_ignore {
    'nui/*',
    'scripts/config.lua',    
}