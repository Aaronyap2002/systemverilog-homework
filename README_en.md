# SystemVerilog Problem Collection for Digital Circuit Synthesis School

[Русский](README_ru.md)

> **Not a day without a line of Verilog**
>
> A collection of problems of increasing complexity
>
> Yuri Panchul, 2021-2024


## Links

* [Digital Circuit Synthesis School](https://engineer.yadro.com/chip-design-school/)
* [First session: introduction to the design flow and combinational logic exercises](https://youtu.be/DFcvEO-gP0c)

<!-- Some markdown video embedding tricks from https://stackoverflow.com/questions/4279611/how-to-embed-a-video-into-github-readme-md -->

[![](https://img.youtube.com/vi/DFcvEO-gP0c/hqdefault.jpg)](https://youtu.be/DFcvEO-gP0c)


## Installation Instructions

The problems can be solved with any Verilog simulator that supports SystemVerilog. They can also be solved with the free Icarus Verilog simulator, which, although it doesn't support full SystemVerilog, does support Verilog 2005 with some SystemVerilog elements sufficient for solving our problems. Icarus Verilog is used with GTKWave, a program for working with timing diagrams. GTKWave won't be needed for the first ten problems, but it's worth installing along with Icarus Verilog for future use.

<p><img src="https://habrastorage.org/r/w1560/getpro/habr/upload_files/5c1/69d/934/5c169d9349c4352399b6cd962cdaa645.png">
<img src="https://habrastorage.org/r/w1560/getpro/habr/upload_files/219/8b5/8d9/2198b58d9b1daa7345c07d2770ca2763.png">
</p>

### Linux Installation

On Ubuntu and Simply Linux, you can install Icarus Verilog and GTKWave with the command:

`sudo apt-get install verilog gtkwave`

---
#### Note:

If you have an old version of Linux distribution (Ubuntu), when installing Icarus
Verilog you will get an old version that doesn't support `always_comb`,
`always_ff` and many other SystemVerilog constructs. How to solve this problem:
1. **Check iverilog version**
    ```bash
    iverilog -v
    ```

    If the iverilog version is less than 11, proceed to step 2.

2. **Install prerequisite packages**
    ```bash
    sudo apt-get install build-essential bison flex gperf readline-common libncurses5-dev nmon autoconf
    ```

3. **Download the latest version of iverilog**

   As of today (12.10.2023) the latest version of iverilog is: 12.0
   Go to the [link](https://sourceforge.net/projects/iverilog/files/iverilog/12.0/) and download the archive.

4. **Build iverilog**
    - Extract the archive:
        ```bash
        tar -xzf verilog-12.0.tar.gz
        ```

    - Enter the extracted folder:
        ```bash
        cd verilog-12.0
        ```

    - Configure iverilog:
        ```bash
        ./configure --prefix=/usr
        ```

    - Test the Icarus build
        ```bash
        make check
        ```
        As a result, several `Hello, world!` messages will appear in the terminal

    - Install Icarus
        ```bash
        sudo make install
        ```
---
### Verilator

Additionally, to check code for some syntax and style errors, you can install Verilator (version 5.002+).

For Ubuntu 23.04 and above:

`sudo apt-get install verilator`

For earlier versions of Ubuntu or other distributions, you can install Verilator along with [OSS CAD SUITE](https://github.com/YosysHQ/oss-cad-suite-build?tab=readme-ov-file#installation)

In OSS CAD SUITE for environment setup, it's recommended to use `export PATH="<extracted_location>/oss-cad-suite/bin:$PATH"`, as `source <extracted_location>/oss-cad-suite/environment` will require additional `unset VERILATOR_ROOT`

For checking, add the `--lint` or `-l` option to the script:
`./run_linux_mac.sh --lint`

The result will appear in the `lint.txt` file

---
### Windows Installation

The Windows version of Icarus Verilog can be downloaded [from this site](https://bleyer.org/icarus/)

[Video instruction for installing Icarus Verilog on Windows](https://youtu.be/5Kync4z5VOw)


[![](https://img.youtube.com/vi/5Kync4z5VOw/hqdefault.jpg)](https://www.youtube.com/watch?v=5Kync4z5VOw)

### Apple Mac Installation

Icarus can even be installed on Apple Mac, which is unusual for EDA tools (EDA - Electronic Design Automation). This can be done in the console using the brew program:

`brew install icarus-verilog`

[Video instruction for installing Icarus Verilog on MacOS](https://youtu.be/jUYkYoYr8hs)


[![](https://img.youtube.com/vi/jUYkYoYr8hs/hqdefault.jpg)](https://www.youtube.com/watch?v=jUYkYoYr8hs)


## Running and Checking Assignments

To check problems on Linux and MacOS, you need to open a console in the folder with assignments and run the script `./run_linux_mac.sh`. It will create a _log.txt_ file with the results of compilation and simulation of all problems in the set.

To check problems on Windows, you need to open a console in the folder with assignments and run the batch file `run_windows.bat`. It will also create a _log.txt_ file with the check results.

After the test for all problems shows **PASS**, you can submit it for teacher review.

## GTKWave Alternative

Instead of GTKWave, you can use the [Surfer](https://surfer-project.org/) diagram viewing program.

Surfer looks much better on modern monitors (especially in Wayland), works faster and can be used from a browser without installation.

![Surfer](https://gitlab.com/surfer-project/surfer/-/raw/main/snapshots/render_readme_screenshot.png)


## Recommended Literature to Help Solve Problems

<!-- A feature of Markdown format is that lists are numbered automatically, so for formatting "as a list" they use the sequence "1." -->

1. [Harris D.M., Harris S.L., "Digital Design and Computer Architecture: RISC-V"](https://dmkpress.com/catalog/electronics/circuit_design/978-5-97060-961-3). There is a [tablet version for the previous edition](https://silicon-russia.com/public_materials/2018_01_15_latest_harris_harris_ru_barabanov_version/digital_design_rus-25.10.2017.pdf) (based on MIPS architecture), and for that there are shorter [lecture slides](http://www.silicon-russia.com/public_materials/2016_09_01_harris_and_harris_slides/DDCA2e_LectureSlides_Ru_20160901.zip).
![](https://habrastorage.org/r/w1560/getpro/habr/upload_files/26c/817/9c3/26c8179c34c52fa937cd2200f789c3d0.png)

1. [Romanov A.Yu., Panchul Yu.V. and collective of authors. "Digital Synthesis. Practical Course"](https://dmkpress.com/catalog/electronics/circuit_design/978-5-97060-850-0/)