{-# OPTIONS_HADDOCK prune, ignore-exports #-}

{------------------------------------------------------------------------------}
{- | Октябрьский конкурс по ФП в 2014 году.

   Автор:     Душкин Р. В.
   Проект:    FPContest

   Задача: создание ключей для криптографии с вращением матрицы.
   
   
                                                                              -}
{------------------------------------------------------------------------------}

module RotatingKey
(
  -- * Функции
  main
)
where

{-[ СЕКЦИЯ ИМПОРТА ]-----------------------------------------------------------}

import Control.Arrow ((&&&))
import Control.Monad (replicateM)
import Data.List (nub, sort, transpose)

{-[ СИНОНИМЫ ТИПОВ ]-----------------------------------------------------------}

-- | Тип для представления одной строки матрицы (вектора). Представляет собой
--   список.
type Vector a = [a]

-- | Тип для представления матрицы. Представляет собой список векторов (то есть
--   список списков). Разработчик должен самостоятельно следить за тем, чтобы
--   размерность всех векторов (длины списков) были одинаковыми.
type Matrix a = [Vector a]

{-[ ФУНКЦИИ ]------------------------------------------------------------------}

-- | Функция для вражения заданной матрицы на 90 градусов против часовой
--   стрелки.
rotate90  = transpose . map reverse

-- | Функция для вражения заданной матрицы на 180 градусов против часовой
--   стрелки.
rotate180 = reverse . map reverse

-- | Функция для вражения заданной матрицы на 270 градусов против часовой
--   стрелки.
rotate270 = map reverse . transpose

-- | Специальная функция для разбивки заданного списка на подсписки заданной
--   длины.
makeMatrix i s | null s     = []
               | otherwise  = let (h, t) = splitAt i s
                              in   h : makeMatrix i t

-- | Функция для поэлементного сложения двух матриц.
sumMatrices = zipWith (zipWith (+))

-- | Предикат для проверки того, является ли заданная матрица подходящей для
--   решения.
goodMatrix = all (all (== 1))

-- | Основная функция модуля, осуществляющая перебор и поиск матриц, подходящих
--   в качестве решения.
main n = map head $
           nub $
           map (sort . rotations . snd) $
           filter (\(m, _) -> goodMatrix m) $
           map ((foldr1 sumMatrices &&& head) .
                rotations .
                makeMatrix n) $
           filter (\l -> sum l == n4) $
           replicateM (n^2) [0, 1]
  where
    n4 | odd n     = 1 + (n^2 - 1) `div` 4
       | otherwise = (n^2) `div` 4
    
    rotations m = map ($ m) [id, rotate90, rotate180, rotate270]

{-[ КОНЕЦ МОДУЛЯ ]-------------------------------------------------------------}
