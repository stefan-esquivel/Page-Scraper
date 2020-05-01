#!/bin/bash
###############################################################
# Name of File: Page-Scraper.sh
# Description: An attempt at crude page scraping using bash.
#
# Coder: Triston Line
#
# Date last edited: April 22
#Note: This file was created on Earth Day. To celebrate, I've added an easter egg for future earth days.
################################################################
#Pre-Production Variables
rootdir=/home/scrape
workingdir=temp
archivedir=archive
logdir=logs
#The working directory represents all file IO, whereas archivedir is a debug/log directory. 
#
###Section 1 - Pulling the Page & Extracting URLs###
#
#Wget Downloads the page after executing the file "./Page-Scraper.sh https://newegg.ca/search"
wget -e robots=off -O $rootdir/$workingdir/initreq.html -o $rootdir/$logdir $1

#CP will copy the file to an archive directory along the way...
cp $rootdir/$workingdir/initreq.html $rootdir/$archivedir/initreqraw.html

#And now grep will execute multiple stages of retrieval....
#Stage 1 - Inital Regex
grep -Eoi '<a [^>]+>' $rootdir/$workingdir/initreq.html > $rootdir/$workingdir/outputstage1.txt
cp $rootdir/$workingdir/outputstage1.txt $rootdir/$archivedir/"outputstage1$(date +"%Y_%m_%d_%I_%M_%p").txt"

#Stage 2 - Futher Processing
cat $rootdir/$workingdir/outputstage1.txt | sed 's/href=/\nhref=/g' | grep href=\" > $rootdir/$workingdir/outputstage2.txt
cp $rootdir/$workingdir/outputstage2.txt $rootdir/$archivedir/"outputstage2$(date +"%Y_%m_%d_%I_%M_%p").txt"

#Stage 3 - Final URL Extraction
cat $rootdir/$workingdir/outputstage2.txt | sed 's/.*href="//g;s/".*//g' | grep -v -i ".void" > $rootdir/$workingdir/outputstage3.txt
cp $rootdir/$workingdir/outputstage3.txt $rootdir/$archivedir/"outputstage3$(date +"%Y_%m_%d_%I_%M_%p").txt"

#
###Section 2 - Sorting URLs and Pulling Listings###
#
cat $rootdir/$workingdir/outputstage3.txt | grep -i item > $rootdir/$workingdir/outputstage4.txt
cp $rootdir/$workingdir/outputstage3.txt $rootdir/$archivedir/"outputstage4$(date +"%Y_%m_%d_%I_%M_%p").txt"

wget -e robots=off --random-wait --directory-prefix=$rootdir/$workingdir -o $rootdir/$logdir --input-file=$rootdir/$workingdir/outputstage4.txt
rm -rf $rootdir/$workingdir/*.1
rm -rf $rootdir/$workingdir/*FeedBackis=true
#Need a way to keep track of all the NewEgg listings downloaded, they all have such wonky mofo names.
#cat all newegg listings | grep -e 'id="Specs"'
#xmllint --noout --html --xpath "//div[@id='Specs']" /home/scrape/temp/listing_file > /home/scrape/temp/specs.html 2> /dev/null
#html2text specs.html > specs.txt
#The last part above is handy for viewing the specs but it won't help much when converting to csv!

#Egg
TODAY=`date +%j`			#Today, any ol' day
EARTHDAY=`date -d 22-April +%j`		#Earth day, maintaining format
if  [ "$TODAY" = "$EARTHDAY" ]; then
   echo "Happy Earth Day!"
 else
   echo ""
fi
