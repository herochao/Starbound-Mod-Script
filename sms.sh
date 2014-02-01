#!/bin/bash
#This Script extracts a Mod to its prefered Target
#example ./SBMI.sh Mod1.zip Mod2.rar Mod3.zip
#
#depends on unzip and unrar
								
StarboundModFolder=~/.local/share/Steam/SteamApps/common/Starbound/mods/	#!!! The location of /Starbound/mods/, change if you
										#changed your steam games folder or are running 
										#a not Linux os



if ! [  -d "$StarboundModFolder" ]						#Check for Mod Folder
	then
		echo "Folder not found! Please change line StarboundModFolder=$StarboundModFolder in this script to /your/location/Starbound/mods/ "
		exit 1
	fi

Files=( "$@" )
echo ""
for arg in "${Files[@]}" 
	do
		
		if [ -f "$arg" ]
			then
			filename=$(basename "$arg")					#get Filenameextension, for desicion between zip/rar
			extension="${filename##*.}"
			if [ "$extension" = "zip" ]					#if branch for Zip files
				then
				if $(unzip -Z -1 "$arg" | grep -q modinfo)
				then
				unzip -Z -1 "$arg" | xargs -i -d '\n' rm -r "${StarboundModFolder}{}" 2>/dev/null	#get content of Zip and remove allready existing content from Starbound folder (deletes previous versions of the Mod)
				unzip "$arg" -d "${StarboundModFolder}"	 				#extract the Zip file to Starbound/mods/
				echo  "$arg succesfully extracted
"					#success
				else
					echo "No Modinfo Found. Is this a Mod? $arg
"
				fi
			elif [ "$extension" = "rar" ]					#if branch for Rar files, does the same as the branch for Zip files
			     then
				if $(unrar vb "$arg" | grep -q modinfo)
				then
				unrar vb "$arg" | xargs -i -d '\n' rm -r "${StarboundModFolder}{}" 2>/dev/null
				unrar x "$arg" "${StarboundModFolder}"
				echo  "$arg succesfully extracted
"
				else
					echo "No Modinfo Found. Is this a Mod? $arg
"
				fi
			else								#if branch for other file types, report if you'd like to have support for a special type
				echo "Filetype not supported: $arg
"										
			fi

		else
			echo "File not Found! $arg"							#branch if the file doesn't exist
		fi
done
echo "Completed!
---------------

Current mods:"											
ls -1A --color=always "${StarboundModFolder}"							#list current mods (files and folders in Starbound/mods)
echo ""