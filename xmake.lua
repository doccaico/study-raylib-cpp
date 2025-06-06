-- [Build and run]
-- $ xmake b game && xmake run

set_project("game")

set_languages("cxx23")

target("game")
    set_kind("binary")  

    add_files("src/*.cpp")

    add_includedirs("src", "vendor/raylib/include")

    if is_os("windows") then
        add_linkdirs("vendor/raylib/lib")
        add_links("raylibdll")
        add_syslinks("gdi32", "winmm")
    end
