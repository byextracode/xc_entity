fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "xc_entity"
version "1.0.0"
description "Entity Info Getter. Provides entity owner ID (if networked) and entity model hash."
author "wibowo#7184"

shared_script "@ox_lib/init.lua"
shared_script "config.lua"

client_script "**/cl_*.lua"
server_script "**/sv_*.lua"

dependencies {
    "ox_lib"
}