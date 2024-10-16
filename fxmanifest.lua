fx_version "cerulean"
game "gta5"
lua54 "yes"
this_is_a_map 'yes'


author "Yelloon"
version "1.0.0"
description ""

shared_script {
    "@vrp/lib/Utils.lua",
    "config/*"
}

client_scripts {
    "src/client.lua",
}

server_scripts {
    "src/server.lua",
}
