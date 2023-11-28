cmake_minimum_required(VERSION 3.15.1)

project(aoc2023 LANGUAGES Swift)

set( BINARY_NAME 1)

set( SOURCES
  Sources/main.swift
)

add_executable(${BINARY_NAME} ${SOURCES})