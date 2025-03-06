add_rules("mode.debug", "mode.release")

set_languages("c11", "c++17")

set_warnings("all")

-- set_policy("build.c++.modules", true)
add_requires("llvm", "mold")


add_rules("plugin.compile_commands.autoupdate", { outputdir = "./." })

set_toolchains("clang")

target("jit_calc")
    set_kind("binary")
    add_files("src/*.cpp")
    add_includedirs("include")

    add_links("mimalloc")
    add_linkdirs("/home/lan/mimalloc/build")

    -- 依赖llvm编译器框架和一个并行链接器
    add_packages("llvm", "mold")

    package("llvm")
    if is_plat("windows") then
        if is_mode("release") then
            add_urls("https://github.com/clice-project/llvm-binary/releases/download/$(version)/x64-windows-msvc-release.7z")
            add_versions("20.0.0", "4ef335845ebb52f8237bda3bcc7246b06085fdf5edc5cc6cf7f3a7c9ef655c09")
        else
        end
    elseif is_plat("linux") then
        if is_mode("debug") then
            add_urls("https://github.com/clice-project/llvm-binary/releases/download/$(version)/x86_64-linux-gnu-debug.tar.xz")
            add_versions("20.0.0", "7dc045424a9667f20845dec058d211476b84300ebcfc8c3a3aabf41bff37cfd9")
        elseif is_mode("release") then
            add_urls("https://github.com/clice-project/llvm-binary/releases/download/$(version)/x86_64-linux-gnu-release.tar.xz")
            add_versions("20.0.0", "30ba7357eb40000f1d13d92242f7d87c3ff623e62205a41d10334d605739af89")
        end
    end

    if is_plat("windows") then
        add_configs("runtimes", {description = "Set compiler runtimes.", default = "MD", readonly = true})
    elseif is_plat("linux") then
        if is_mode("debug") then
            add_configs("shared", {description = "Build shared library.", default = true, type = "boolean", readonly = true})
        end
    end

    if is_plat("windows", "mingw") then
        add_syslinks("version", "ntdll")
    end

    on_install(function (package)
        if not package:config("shared") then
            package:add("defines", "CLANG_BUILD_STATIC")
        end

        os.mv("bin", package:installdir())
        os.mv("lib", package:installdir())
        os.mv("include", package:installdir())
    end)

--
-- If you want to known more usage about xmake, please see https://xmake.io
--
-- ## FAQ
--
-- You can enter the project directory firstly before building project.
--
--   $ cd projectdir
--
-- 1. How to build project?
--
--   $ xmake
--
-- 2. How to configure project?
--
--   $ xmake f -p [macosx|linux|iphoneos ..] -a [x86_64|i386|arm64 ..] -m [debug|release]
--
-- 3. Where is the build output directory?
--
--   The default output directory is `./build` and you can configure the output directory.
--
--   $ xmake f -o outputdir
--   $ xmake
--
-- 4. How to run and debug target after building project?
--
--   $ xmake run [targetname]
--   $ xmake run -d [targetname]
--
-- 5. How to install target to the system directory or other output directory?
--
--   $ xmake install
--   $ xmake install -o installdir
--
-- 6. Add some frequently-used compilation flags in xmake.lua
--
-- @code
--    -- add debug and release modes
--    add_rules("mode.debug", "mode.release")
--
--    -- add macro definition
--    add_defines("NDEBUG", "_GNU_SOURCE=1")
--
--    -- set warning all as error
--    set_warnings("all", "error")
--
--    -- set language: c99, c++11
--    set_languages("c99", "c++11")
--
--    -- set optimization: none, faster, fastest, smallest
--    set_optimize("fastest")
--
--    -- add include search directories
--    add_includedirs("/usr/include", "/usr/local/include")
--
--    -- add link libraries and search directories
--    add_links("tbox")
--    add_linkdirs("/usr/local/lib", "/usr/lib")
--
--    -- add system link libraries
--    add_syslinks("z", "pthread")
--
--    -- add compilation and link flags
--    add_cxflags("-stdnolib", "-fno-strict-aliasing")
--    add_ldflags("-L/usr/local/lib", "-lpthread", {force = true})
--
-- @endcode
--

