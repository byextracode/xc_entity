fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "xc_entity"
version "1.0.0"
description "Provides entity management."
author "wibowo#7184"

shared_script "@ox_lib/init.lua"
shared_script "config.lua"

client_script "client/*.lua"
server_script "server/*.lua"

dependencies {
    "ox_lib"
}