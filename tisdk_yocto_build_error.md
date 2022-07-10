## build error..
그대로 빌드가 되지 않는다.  
처음 빌드하는 경우, 몇가지 빌드에러를 수정해야한다.  
-----------------------------------------------------------------  
  
### mobile-broadband-provider-info패키지 branch 이름 수정 
아래 에러가 뜬다.  
~~~
mobile-broadband-provider-info-1_20201225-r0 do_fetch: Bitbake Fetcher Error: FetchError('Unable to fetch URL from any source.', 'git://gitlab.gnome.org/GNOME/mobile-broadband-provider-info.git;protocol=https;branch=master')
~~~
로그 상으로는 git repository url을 찾을 수 없다고 한다.  
검색해보면 브랜치 이름이 main으로 변경되었기 때문이라고 한다.  
https://stackoverflow.com/questions/68215012/how-do-i-fix-a-bitbake-failed-to-fetch-git-error
  
  
아래처럼 해당 bb파일을 찾아보면 아래 경로에 있는 것을 확인할 수 있다.  
~~~
sy@ubuntu:~/tisdk/build$ find ../ -name mobile-broadband-provider*.bb
../sources/oe-core/meta/recipes-connectivity/mobile-broadband-provider-info/mobile-broadband-provider-info_git.bb
~~~
  
mobile-broadband-provider-info_git.bb파일을 열어서 branch 이름을 master에서 main으로 바꾸면 해당 에러는 없어진다.  
  
  
### libsocketcan(git url이 변경됨 -> SRC_URI를 수정)
로그  
~~~
Initialising tasks: 100% |#########################################################################################################################################################################################################################################| Time: 0:00:03
Sstate summary: Wanted 1094 Found 0 Missed 1094 Current 208 (0% match, 15% complete)
NOTE: Executing Tasks
WARNING: libsocketcan-0.0.11-r0 do_fetch: Failed to fetch URL git://git.pengutronix.de/git/tools/libsocketcan.git;protocol=git;branch=master, attempting MIRRORS if available
ERROR: libsocketcan-0.0.11-r0 do_fetch: Fetcher failure: Fetch command export PSEUDO_DISABLED=1; export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"; export SSH_AGENT_PID="1595"; export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"; export PATH="/home/sy/tisdk/sources/oe-core/scripts:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/recipe-sysroot-native/usr/bin/arm-linux-gnueabi:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/recipe-sysroot/usr/bin/crossscripts:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/recipe-sysroot-native/usr/sbin:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/recipe-sysroot-native/usr/bin:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/recipe-sysroot-native/sbin:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/recipe-sysroot-native/bin:/home/sy/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf/bin:/home/sy/tisdk/sources/bitbake/bin:/home/sy/tisdk/build/arago-tmp-external-arm-glibc/hosttools"; export HOME="/home/sy"; LANG=C git -c core.fsyncobjectfiles=0 clone --bare --mirror "git://git.pengutronix.de/git/tools/libsocketcan.git" /home/sy/tisdk/downloads/git2/git.pengutronix.de.git.tools.libsocketcan.git --progress failed with exit code 128, no output
ERROR: libsocketcan-0.0.11-r0 do_fetch: Bitbake Fetcher Error: FetchError('Unable to fetch URL from any source.', 'git://git.pengutronix.de/git/tools/libsocketcan.git;protocol=git;branch=master')
ERROR: Logfile of failure stored in: /home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/armv7at2hf-neon-linux-gnueabi/libsocketcan/0.0.11-r0/temp/log.do_fetch.1278764
ERROR: Task (/home/sy/tisdk/sources/meta-openembedded/meta-oe/recipes-extended/socketcan/libsocketcan_0.0.11.bb:do_fetch) failed with exit code '1'
WARNING: python3-pybind11-2.4.3-r0 do_fetch: Failed to fetch URL https://files.pythonhosted.org/packages/source/p/pybind11/pybind11-2.4.3.tar.gz, attempting MIRRORS if available
~~~
  
로그를 보면 아래처럼 SRC URI가 잘못되어서 do_fetch중에 발생한 에러인 것을 알 수 있다.  
~~~
ERROR: libsocketcan-0.0.11-r0 do_fetch: Bitbake Fetcher Error: FetchError('Unable to fetch URL from any source.', 'git://git.pengutronix.de/git/tools/libsocketcan.git;protocol=git;
~~~
  
bb파일(recipe)수정  
git repository url이 변경되어서 이전의 SRC_URI로는 download가 되지 않어서 error가 발생된다.
libsocketcan bb파일(libsocketcan*.bb, recipe)의 SRC_URI를 아래처럼 수정한다.  
~~~
sudo vim ../sources/meta-openembedded/meta-oe/recipes-extended/socketcan/libsocketcan_0.0.11.bb  

SUMMARY = "Control basic functions in socketcan from userspace"
HOMEPAGE = "http://www.pengutronix.de"
SECTION = "libs/network"

LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://src/libsocketcan.c;beginline=3;endline=17;md5=97e38adced4385d8fba1ae2437cedee1"

SRCREV = "0ff01ae7e4d271a7b81241e7a7026bfcea0add3f"

SRC_URI = "git://git.pengutronix.de/git/tools/libsocketcan.git;protocol=git;branch=master"

S = "${WORKDIR}/git"

inherit autotools pkgconfig
~~~  
  
### ca-certificates bb파일 수정(protocol을 git -> https로 변경)
로그  
~~~
NOTE: Executing Tasks
WARNING: ca-certificates-20211016-r0 do_fetch: Failed to fetch URL git://salsa.debian.org/debian/ca-certificates.git;protocol=https;branch=master, attempting MIRRORS if available
ERROR: linux-ti-staging-5.10.100+gitAUTOINC+7a7a3af903-r22b.arago5.tisdk0 do_package: Error executing a python function in exec_func_python() autogenerated:

The stack trace of python calls that resulted in this exception/failure was:
File: 'exec_func_python() autogenerated', lineno: 2, function: <module>
     0001:
~~~
  
repository 주소  
~~~
git://salsa.debian.org/debian/ca-certificates.git;protocol=https;branch=master,
https://salsa.debian.org/debian/ca-certificates.git
~~~
  
bb파일(recipe) 위치  
~~~
sy@ubuntu:~/tisdk/build$ find ../ -name ca-certificates*bb
../sources/oe-core/meta/recipes-support/ca-certificates/ca-certificates_20211016.bb
~~~
  
아래 url을 보면 protocol을 http로 바꿔야한다.  
https://stackoverflow.com/questions/25501692/turn-off-source-checksum-check-yocto
  
  
  
## kernel, uboot recipe 빌드 에러 수정.
로그  
~~~
Initialising tasks: 100% |#########################################################################################################################################################################################################################################| Time: 0:00:02
Sstate summary: Wanted 1038 Found 0 Missed 1038 Current 264 (0% match, 20% complete)
NOTE: Executing Tasks
ERROR: linux-ti-staging-5.10.100+gitAUTOINC+7a7a3af903-r22b.arago5.tisdk0 do_package: Error executing a python function in exec_func_python() autogenerated:

The stack trace of python calls that resulted in this exception/failure was:
File: 'exec_func_python() autogenerated', lineno: 2, function: <module>
     0001:
 *** 0002:do_package(d)
     0003:
File: '/home/sy/tisdk/sources/oe-core/meta/classes/package.bbclass', lineno: 2315, function: do_package
     2311:
     2312:    cpath = oe.cachedpath.CachedPath()
     2313:
     2314:    for f in (d.getVar('PACKAGESPLITFUNCS') or '').split():
 *** 2315:        bb.build.exec_func(f, d)
     2316:
     2317:    ###########################################################################
     2318:    # Process PKGDEST
     2319:    ###########################################################################
File: '/home/sy/tisdk/sources/bitbake/lib/bb/build.py', lineno: 254, function: exec_func
     0250:    with bb.utils.fileslocked(lockfiles):
     0251:        if ispython:
     0252:            exec_func_python(func, d, runfile, cwd=adir)
     0253:        else:
 *** 0254:            exec_func_shell(func, d, runfile, cwd=adir)
     0255:
     0256:    try:
     0257:        curcwd = os.getcwd()
     0258:    except:
File: '/home/sy/tisdk/sources/bitbake/lib/bb/build.py', lineno: 455, function: exec_func_shell
     0451:    with open(fifopath, 'r+b', buffering=0) as fifo:
     0452:        try:
     0453:            bb.debug(2, "Executing shell function %s" % func)
     0454:            with open(os.devnull, 'r+') as stdin, logfile:
 *** 0455:                bb.process.run(cmd, shell=False, stdin=stdin, log=logfile, extrafiles=[(fifo,readfifo)])
     0456:        finally:
     0457:            os.unlink(fifopath)
     0458:
     0459:    bb.debug(2, "Shell function %s finished" % func)
File: '/home/sy/tisdk/sources/bitbake/lib/bb/process.py', lineno: 184, function: run
     0180:
     0181:    if pipe.returncode != 0:
     0182:        if log:
     0183:            # Don't duplicate the output in the exception if logging it
 *** 0184:            raise ExecutionError(cmd, pipe.returncode, None, None)
     0185:        raise ExecutionError(cmd, pipe.returncode, stdout, stderr)
     0186:    return stdout, stderr
Exception: bb.process.ExecutionError: Execution of '/home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/am335x_evm-linux-gnueabi/linux-ti-staging/5.10.100+gitAUTOINC+7a7a3af903-r22b.arago5.tisdk0/temp/run.populate_srcipk_package.1377423' failed with exit code 1

ERROR: Logfile of failure stored in: /home/sy/tisdk/build/arago-tmp-external-arm-glibc/work/am335x_evm-linux-gnueabi/linux-ti-staging/5.10.100+gitAUTOINC+7a7a3af903-r22b.arago5.tisdk0/temp/log.do_package.1377423
ERROR: Task (/home/sy/tisdk/sources/meta-ti/recipes-kernel/linux/linux-ti-staging_5.10.bb:do_package) failed with exit code '1'
NOTE: Tasks Summary: Attempted 1566 tasks of which 1554 didn't need to be rerun and 1 failed.
NOTE: Writing buildhistory
NOTE: Writing buildhistory took: 1 seconds

Summary: 1 task failed:
  /home/sy/tisdk/sources/meta-ti/recipes-kernel/linux/linux-ti-staging_5.10.bb:do_package
Summary: There was 1 ERROR message shown, returning a non-zero exit code.
~~~  
  
아래 에러 내용으로 검색해보면 수정포인트가 나온다..  
~~~
ERROR: linux-ti-staging-5.10.100 do_package: Error executing a python function in exec_func_python() autogenerated:
~~~  
  
아래의 url 중 ti e2e(faq사이트)를 확인해보면 최신 SDK에서는 get_git_revision대신 getVar를 사용한다고 한다.  
https://www.google.com/search?q=ERROR%3A+linux-ti-staging-5.10.100+do_package%3A+Error+executing+a+python+function+in+exec_func_python%28%29+autogenerated%3A&client=firefox-b-d&ei=4NKIYrqzNYr-0gS_8oDADA&ved=0ahUKEwi6o_-dxPD3AhUKv5QKHT85AMgQ4dUDCA0&uact=5&oq=ERROR%3A+linux-ti-staging-5.10.100+do_package%3A+Error+executing+a+python+function+in+exec_func_python%28%29+autogenerated%3A&gs_lcp=Cgdnd3Mtd2l6EANKBAhBGAFKBAhGGABQoAVY5Uhg9EtoAXAAeACAAQCIAQCSAQCYAQCgAQHAAQE&sclient=gws-wiz
  
https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1099414/tda4vm-sdk-8-2-psdkla-build-failure-error-executing-a-python-function-in-exec_func_python-autogenerated
  
https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1097720/faq-yocto-building-the-linux-sdk-results-in-do_package-failures-for-linux-kernel-and-u-boot
  
https://git.ti.com/cgit/arago-project/meta-ti/commit/?h=dunfell-next&id=ccbe45c06b2fddf73b4a5c596214fc86b0968d39
  
https://git.ti.com/cgit/arago-project/meta-ti/commit/?h=dunfell-next&id=9e6c7d69d8d5700ff22ca03a3d1d1b04bce88f85
  
kernel과 u-boot 모두 수정해주어야 한다.
~~~
vim ../sources/meta-ti/recipes-kernel/linux/setup-defconfig.inc 
#KERNEL_LOCALVERSION = "-g${@get_git_revision('${S}').__str__()[:10]}"
KERNEL_LOCALVERSION = "-g${@d.getVar('SRCPV', True).split('+')[1]}"

vim ../sources/meta-ti/recipes-bsp/u-boot/u-boot-ti.inc
#UBOOT_LOCALVERSION = "-g${@get_git_revision('${S}').__str__()[:10]}"
UBOOT_LOCALVERSION = "-g${@d.getVar('SRCPV', True).split('+')[1]}"
~~~  
  
### 참고
git대신 https로 변경하는 방법.  
아래처럼 수정했었던 것 같은데, 기억이 안난다.  
다시 새로 받아서 빌드해봐야할 듯.. ㅠㅠ  
~~~
git config --global url."https://github.com/".insteadOf git://github.com/

git config --global url."https://github.com/".insteadOf git://github.com/


아래 처럼오타나면 git config --list으로 현재 대체 주소문자열 확인
git config --global url."https://github.com:".insteadOf git://github.com/

아래 명령처럼 unset함..
git config --global --unset user.email
git config --global --unset url."https://github.com:".insteadOf으로 해제한 후에
다시 아래 명령.
~~~