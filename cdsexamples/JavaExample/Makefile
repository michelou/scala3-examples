##
## Copyright (c) 2018-2026 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

JAVAC_FLAGS = -deprecation
JAVA_FLAGS  = -classpath "$(CLASSES_DIR)"

##############################################################################
## main rules

SOURCES = $(shell $(FIND) "$(SOURCE_DIR)/main/java" -type f -name "*.java")
TARGET  = $(TARGET_DIR)/.latest-build

OPTS_FILE    = $(TARGET_DIR)/javac_opts.txt
SOURCES_FILE = $(TARGET_DIR)/javac_sources.txt

MAIN_CLASS = cdsexamples.Main
MAIN_ARGS ?= 

all: build

build: deps $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || "$(MKDIR)" -p "$(CLASSES_DIR)"
	@$(ECHO) $(JAVAC_FLAGS) -d "$(CLASSES_DIR)" > "$(OPTS_FILE)"
	@$(ECHO) $(SOURCES) > "$(SOURCES_FILE)"
	"$(JAVAC)" "@$(OPTS_FILE)" "@$(SOURCES_FILE)"
	@$(TOUCH) "$(TARGET)"

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

compile: build

run: build
	"$(JAVA)" $(JAVA_FLAGS) $(MAIN_CLASS) $(MAIN_ARGS)

help:
	@$(ECHO) "Usage: make all|build|clean|run|test"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "    all    alias for build"
	@$(ECHO) "    build  compile Java source files"
	@$(ECHO) "    clean  delete generated files"
	@$(ECHO) "    doc    generate HTML documentation"
	@$(ECHO) "    help   print this help message"
	@$(ECHO) "    run    execute the main program \"$(MAIN_CLASS)\""
	@$(ECHO) "    test   execute unit tests with JUnit"

##############################################################################
## doc rules

DOC_TARGET_DIR = $(TARGET_DIR)/docs
DOC_SOURCES    = $(shell $(FIND) "$(SOURCE_DIR)/main/java" -type f -name "*.java" 2>/dev/null)
DOC_TARGET     = $(DOC_TARGET_DIR)/.latest-build

PROJECT_NAME    ?= $(shell basename $(CURDIR))
PROJECT_URL     ?= https://github.com/$(USERNAME)/scala3-examples
PROJECT_VERSION ?= 1.0.0

DOC_OPTS_FILE    = $(TARGET_DIR)/javadoc_opts.txt
DOC_SOURCES_FILE = $(TARGET_DIR)/javadoc_sources.txt

$(DOC_TARGET): $(DOC_SOURCES)
	[ -d "$(DOC_TARGET_DIR)" ] || "$(MKDIR)" -p "$(DOC_TARGET_DIR)"
	@$(ECHO) -d "$(DOC_TARGET_DIR)" -doctitle "$(PROJECT_NAME)" -footer "$(PROJECT_VERSION)" -windowtitle "$(PROJECT_NAME)" > "$(DOC_OPTS_FILE)"
	@$(ECHO) $(DOC_SOURCES) > "$(DOC_SOURCES_FILE)"
	"$(JAVADOC)" "@$(DOC_OPTS_FILE)" "@$(DOC_SOURCES_FILE)"
	@$(TOUCH) "$(DOC_TARGET)"

doc: build $(DOC_TARGET)

##############################################################################
## test rules

TEST_SOURCES     = $(shell $(FIND) "$(SOURCE_DIR)/test/java" -type f -name "*.java" 2>/dev/null)
TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_TARGET      = $(TARGET_DIR)/.latest-test-build

TEST_OPTS_FILE    = $(TARGET_DIR)/javac_test_opts.txt
TEST_SOURCES_FILE = $(TARGET_DIR)/javac_test_sources.txt

TEST_MAIN_CLASS = cdsexamples.MainTest
TEST_CPATH      = $(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(PSEP)$(SPECS2_CORE_JAR)$(PSEP)$(SPECS2_JUNIT_JAR)$(PSEP)$(SPECS2_MATCHER_JAR)$(PSEP)$(CLASSES_DIR)$(PSEP)$(TEST_CLASSES_DIR)

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(TEST_CLASSES_DIR)" ] || "$(MKDIR)" -p "$(TEST_CLASSES_DIR)"
	@$(ECHO) $(SCALAC_FLAGS) -classpath "$(TEST_CPATH)" -d "$(TEST_CLASSES_DIR)" > "$(TEST_OPTS_FILE)"
	@$(ECHO) $(TEST_SOURCES) > "$(TEST_SOURCES_FILE)"
	"$(JAVAC)" "@$(TEST_OPTS_FILE)" "@$(TEST_SOURCES_FILE)"
	@$(TOUCH) "$(TEST_TARGET)"

test: build $(TEST_TARGET)
	"$(JAVA)" -classpath "$(TEST_CPATH)" org.junit.runner.JUnitCore $(TEST_MAIN_CLASS)

##############################################################################
## phony

.PHONY: all build clean compile deps doc help lint run test

.SUFFIXES:
.SUFFIXES: .class .jar .java
