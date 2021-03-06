# Компиляция

## Простая компиляция
    gcc -O2 -o silentfl main.c

## Продвинутая компиляция на платформе x86
    gcc -Ofast -march=native -m32 -mfpmath=sse -funroll-loops -o silentfl main.c

## Продвинутая компиляция на платформе x86_64
    gcc -Ofast -march=native -m64 -funroll-loops -o silentfl main.c

# Запуск и проверка результата:
    ./silentfl ../../bigmatrix 6001 4001 | perl -ne '/Digit (\d)/; print $1; END { print "\n" }' > result
    diff result ../../pi1000000.txt

# Примеры запуска

## Мое решение (простая компиляция)
    ➜  time ./silentfl ../../bigmatrix 6001 4001 > /dev/null
    real  0m1.730s user  0m1.620s sys 0m0.092s
    
## Мое решение (продвинутая компиляция x86)
    ➜  time ./silentfl ../../bigmatrix 6001 4001 > /dev/null
    real  0m1.501s user  0m1.420s sys 0m0.064s

## Решение maxim-komar (для сравнения)
    ➜  time ./august ../bigmatrix 6001 4001 > /dev/null 
    real  0m3.901s user  0m3.648s sys 0m0.132s

## Решение на машине с конфигурацией pc1.conf

    ➜ time ./silentfl ../bigmatrix 6001 4001 > /dev/null
    ./silentfl ../bigmatrix 6001 4001 > /dev/null  0,38s user 0,00s system 98% cpu 0,385 total
    ➜ time ./silentfl ../bigmatrix 6001 4001 > /dev/null
    ./silentfl ../bigmatrix 6001 4001 > /dev/null  0,38s user 0,00s system 98% cpu 0,385 total
    ➜ time ./silentfl ../bigmatrix 6001 4001 > /dev/null
    ./silentfl ../bigmatrix 6001 4001 > /dev/null  0,37s user 0,01s system 98% cpu 0,385 total


# Пояснения

## Пояснение к алгоритму
    Решение "в лоб": ищем в массиве подмассивы, используя некоторые оптимизации:
    * файл обрабатывается построчно, общий расход памяти соразмерен длине строки;
    * регион сравнения собирается в битовую маску (его длина всего 15 бит);

## Пояснение к ключам компиляции
    * **-march=native** - компиляция под текущую архитектуру, с учетом возможных
      специфичных архитектурных оптимизаций;
    * **-Ofast** аналогично "-O3 -ffast-math" включает более высокий уровень
    оптимизаций и более агрессивные оптимизации для арифметических вычислений
    (например, вещественную реассоциацию)
    * **-m32** 32 битный режим
    * **-mfpmath=sse** включает использование XMM регистров в вещественной
    арифметике (вместо вещественного стека в x87 режиме)
    * **-funroll-loops** включает развертывание циклов
    Как видно из времени выполнения, использование даже таких простых
    оптимизаций дает +15% к производительности

## Дальнейшие пути оптимизации
    Можно еще немного заморочиться:
    * Использовать для чтения-записи прямое отображение файлов в память;
    * Распараллелить поиск цифр, никаких зависимостей, препятствующих этому;
    * Реализовать построение битовой маски на intrisic'ах, или сразу на
      ассемблере, с выравниванием данных
