pics-to-SVG-to-web-font
=======================

Easily transform your gif, png, jpg to svg and create your own web-font in only one command line.

<h1>Installation</h1>
This project has been tested on Ubuntu.
It needs :
<ul>
  <li>zlib</li>
  <li>ruby</li>
  <li>fontforge</li>
  <li>fontcustom</li>
  <li>imagemagick</li>
  <li>potrace</li>
</ul>

Tired of looking for librairies around ?<br />
The script check if everything is setup and if something is missing, it will ask if you want to install it.<br />
Press 'y', enjoy.

<h1>Usage</h1>
<h2>Simple</h2>
Only 2 steps needed :
<ul>
  <li>Copy all your pics into the 'base' folder.</li>
  <li>
  Run the following command :
  </li>
</ul>

  ```
  bash ./generate.sh ./base [gif|png|jpg]
  ```
  For example if you are working with some gifs :
  ```
  bash ./generate.sh ./base gif
  ```
  For now, it is not possible to have multiple types (jpg + gif or gif + png).<br />
  Probably comming soon.
  
  You'll then have 2 new folders : 
  <ul>
  <li>The one containing all the SVG : 'final_svg'</li>
  <li>The one containing the web font : 'web_font'</li>
  </ul>
  
<h2>Format filename</h2>

In case you need to rename all the files because the originals pics have random names or whatever and you can't change them, you can use 'rosetta_stone.txt'.<br />
If this file is not empty, it will try to match and rename all the svg files in the new folder 'final_svg'.<br />
So generated web font will also have new names.<br />

Simply format it like that :
```
random_name_1|new_name_1
random_name_2|new_name_2
random_name_3|new_name_3
```
