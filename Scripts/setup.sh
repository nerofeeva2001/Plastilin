#!/bin/bash
# Создание директории для бинарных файлов и переход в нее
mkdir -p ~/bin
cd ~/bin
# Загрузка исполняемых файлов UCSC Genome Browser
rsync -aP rsync://hgdownload.cse.ucsc.edu/genome/admin/exe/linux.x86_64/ ./
# Предоставление прав на выполнение всех файлов
chmod +x ./*
# Добавление директории ~/bin в PATH и перезагрузка конфигурации оболочки
export PATH=$PATH:~/bin
source ~/.bashrc
# Переход в директорию с blat, список файлов и предоставление прав на выполнение
cd ~/bin/blat
ls -l
chmod +x blat
# Создание символической ссылки на blat и добавление ~/bin в PATH при каждом запуске оболочки
ln -s ~/bin/blat/blat ~/bin/blat_executable
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
source ~/.bashrc
# Установка seqkit с использованием Conda (это не обязательно, я это делаю, так как не хватает ресурсов ноутбука)
conda install -c bioconda seqkit
# Установка CrossMap с использованием pip
pip install CrossMap
