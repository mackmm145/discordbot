@echo off
:restart_bot
ruby bot.rb
timeout 10
goto :restart_bot