echo off
@rem defining buildfile config

set "source_rom=%~dp0FE8_clean.gba"

set "main_event=%~dp0ROMBuildfile.event"

set "target_rom=%~dp0SkillsTest.gba"
set "target_ups=%~dp0SkillsTest.ups"

@rem defining tools

set "c2ea=%~dp0Tools\C2EA\c2ea"
set "textprocess=%~dp0Tools\TextProcess\text-process-classic"
set "ups=%~dp0Tools\ups\ups"
set "parsefile=%~dp0EventAssembler\Tools\ParseFile.exe"
set "tmx2ea=%~dp0Tools\tmx2ea\tmx2ea"

@rem set %~dp0 into a variable because batch is stupid and messes with it when using conditionals?

set "base_dir=%~dp0"

@rem do the actual building

echo Copying ROM

copy "%source_rom%" "%target_rom%"

echo:
echo Assembling

cd "%base_dir%EventAssembler"
ColorzCore A FE8 "-output:%target_rom%" "-input:%main_event%" "--nocash-sym:%target_rom%.sym"

echo:
echo Done!
rem pause
pause
