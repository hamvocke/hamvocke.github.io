---
layout: post
title: Import your DKB account into Homebank
tags: programming
excerpt: Homebank is a great and free personal finance tool. I have written a small converter that allows you to import account data from DKB accounts.
---

Recently I started using [Homebank](http://homebank.free.fr/), a great and free personal finance
tool, to keep track of my budget and spending habits. It takes a little effort to set up but is
really intuitive and straightforward from there.

I started tracking all my spendings and transactions in Homebank a couple of months ago which helped
me getting started with Homebank. Tracking all transactions manually, however, felt really
cumbersome; especially when tracking a fair amount of transactions if you haven't updated
Homebank in a while. 

Sensing that there must be a better way to track your spendings and earnings in Homebank I decided
to investigate a little bit. And as it turns out, there is a better way. My findings might be
helpful for others so I thought I might share.

## Step 1: Export your account data as CSV
To get your transactions from your DKB account into Homebank you need to export your account data as
a CSV file. This can easily be done using the DKB's online banking interface. Just go to
"Kontoumsätze" (for a DKB Cash account) or "Kreditkartenumsätze" (for a Visa account), enter the
desired time frame for your report and then hit the little arrow icon in the top right corner (just 
beneath the printer icon). This will download a CSV file that we can convert and then import into
Homebank.

## Step 2: Download the dkb2homebank converter
Unfortunately the downloaded files are not compatible with Homebank's CSV import interface. If you
try to import the DKB generated CSV files right away, Homebank will simply refuse to do so as it
does not recognize the file as a proper transactions file.

Luckily the Homebank developer has written a [specification of the CSV import
interface](http://homebank.free.fr/help/misc-csvformat.html#txn). It seems
fairly complete and allowed me to write a little converter script that converts the DKB's CSV file
into a Homebank ready CSV file.

[Download the latest version](https://raw.githubusercontent.com/hamvocke/dkb2homebank/master/dkb2homebank.py) 
(_right click_ -> _Save Link as..._) of the converter script and save it on your computer.
It's written in Python and requires you to have Python >= 2.7.4 installed. I've tested it with
Homebank 5.0.0 on a Linux machine but expect it to work on other operating systems with a similar
Homebank version as well.

## Step 3: Convert the CSV file
Now that you've downloaded the _dkb2homebank_ script, you can use it to convert the DKB's CSV file
to a Homebank readable one. To run the script, call it as described in the [readme file on
github](https://github.com/hamvocke/dkb2homebank). You need to provide the type of the CSV file
(currently DKB cash account exports and Visa account exports are supported) and the filename of the
respective CSV file:

    ./dkb2homebank.py --cash yourCashFile.csv

or for Visa account exports:

    ./dkb2homebank.py --visa yourVisaFile.csv

Each of these commands will create a output file called either `cashHomebank.csv` for DKB Cash
accounts or `visaHomebank.csv` for Visa accounts.

## Step 4: Import the converted CSV file into Homebank
You can import the newly created CSV files into Homebank using its import dialog (_File_ ->
_Import_ -> _CSV file..._). This dialog will guide you through the import process. Make sure that
you select the correct account to which the imported data should be added.

After that all your transactions are imported into your Homebank file. You can now start tagging
them as you like to help you get an overview of all your spendings and earnings.

## What else?
If you discover any problems, just contact me or file a bug report on the
[dkb2homebank GitHub repo](https://github.com/hamvocke/dkb2homebank). You can also try to fix or
improve stuff yourself and send me a pull request.

Was this helpful? Feel free to drop me a line!
