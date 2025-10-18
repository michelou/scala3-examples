##
## Copyright (c) 2018-2025 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target
CLASSES_DIR = $(TARGET_DIR)/classes

SCALAC_FLAGS = -deprecation -feature
SCALA_FLAGS  = -classpath "$(CLASSES_DIR)"

##############################################################################
## main rules

SOURCES = $(shell $(FIND) "$(SOURCE_DIR)/main/scala" -type f -name "*.scala")
TARGET  = $(TARGET_DIR)/.latest-build

OPTS_FILE    = $(TARGET_DIR)/scalac_opts.txt
SOURCES_FILE = $(TARGET_DIR)/scalac_sources.txt

MAIN_CLASS = rockthejvm.Main
MAIN_ARGS ?= 

all: build

build: $(TARGET)

$(TARGET): $(SOURCES)
	[ -d "$(CLASSES_DIR)" ] || "$(MKDIR)" -p "$(CLASSES_DIR)"
	@$(ECHO) $(SCALAC_FLAGS) -d "$(CLASSES_DIR)" > "$(OPTS_FILE)"
	@$(ECHO) $(SOURCES) > "$(SOURCES_FILE)"
	"$(SCALAC)" "@$(OPTS_FILE)" "@$(SOURCES_FILE)"
	@$(TOUCH) "$(TARGET)"

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

run: build
	"$(SCALA)" $(SCALA_FLAGS) $(MAIN_CLASS) $(MAIN_ARGS)

help:
	@$(ECHO) "Usage: make all|build|clean|doc|help|lint|run|test"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "    all    alias for build"
	@$(ECHO) "    build  compile Java/Scala source files"
	@$(ECHO) "    clean  delete generated files"
	@$(ECHO) "    doc    generate HTML documentation"
	@$(ECHO) "    help   print this help message"
	@$(ECHO) "    lint   analyze Scala source files with Scalafmt"
	@$(ECHO) "    run    execute main program \"$(MAIN_CLASS)\""
	@$(ECHO) "    test   execute unit tests with JUnit"

##############################################################################
## doc rules

DOC_TARGET_DIR = $(TARGET_DIR)/docs
DOC_SOURCES    = $(shell [ -d "$(CLASSES_DIR)" ] && $(FIND) "$(CLASSES_DIR)" -type f -name "*.tasty")
DOC_TARGET     = $(DOC_TARGET_DIR)/.latest-build

PROJECT_NAME    ?= $(shell basename $(CURDIR))
PROJECT_URL     ?= https://github.com/$(USERNAME)/dotty-examples
PROJECT_VERSION ?= 1.0.0

DOC_OPTS_FILE    = $(TARGET_DIR)/scaladoc_opts.txt
DOC_SOURCES_FILE = $(TARGET_DIR)/scaladoc_sources.txt

$(DOC_TARGET): $(TARGET) $(DOC_SOURCES)
	[ -d "$(DOC_TARGET_DIR)" ] || "$(MKDIR)" -p "$(DOC_TARGET_DIR)"
	@$(ECHO) -siteroot "$(DOC_TARGET_DIR)" -d "$(DOC_TARGET_DIR)" -project "$(PROJECT_NAME)" -project-version "$(PROJECT_VERSION)" > "$(DOC_OPTS_FILE)"
	@$(ECHO) $(DOC_SOURCES) > "$(DOC_SOURCES_FILE)"
	"$(SCALADOC)" "@$(DOC_OPTS_FILE)" "@$(DOC_SOURCES_FILE)"
	@$(TOUCH) "$(DOC_TARGET)"

doc: build $(DOC_TARGET)

##############################################################################
## lint rules

LINT_SOURCES = $(shell $(FIND) "$(SOURCE_DIR)" -type f -name "*.scala")
LINT_TARGET  = $(TARGET_DIR)/.latest-lint

SCALAFMT_CONFIG_FILE = $(shell dirname $(CURDIR))/.scalafmt.conf
SCALAFMT_OPTS = --test --config "$(SCALAFMT_CONFIG_FILE)"

lint: $(LINT_TARGET)

$(LINT_TARGET): $(LINT_SOURCES)
	"$(SCALAFMT)" $(SCALAFMT_OPTS) $(SOURCE_DIR)
	@$(TOUCH) "$(LINT_TARGET)"

##############################################################################
## test rules

TEST_SOURCES     = $(shell [ -d "$(SOURCE_DIR)/test" ] && $(FIND) "$(SOURCE_DIR)/test" -type f -name "*.scala")
TEST_CLASSES_DIR = $(TARGET_DIR)/test-classes
TEST_TARGET      = $(TARGET_DIR)/.latest-test-build

TEST_OPTS_FILE    = $(TARGET_DIR)/scalac_test_opts.txt
TEST_SOURCES_FILE = $(TARGET_DIR)/scalac_test_sources.txt

TEST_MAIN_CLASS = rockthejvm.MainJUnitTest
TEST_CPATH      = $(SCALA_LIB_JAR)$(PSEP)$(SCALA3_LIB_JAR)$(PSEP)$(HAMCREST_JAR)$(PSEP)$(JUNIT_JAR)$(PSEP)$(JUNIT_INTF_JAR)$(PSEP)$(SCALATEST_JAR)$(PSEP)$(SCALACTIC_JAR)$(PSEP)$(SPECS2_CORE_JAR)$(PSEP)$(SPECS2_JUNIT_JAR)$(PSEP)$(SPECS2_MATCHER_JAR)$(PSEP)$(CLASSES_DIR)$(PSEP)$(TEST_CLASSES_DIR)

$(TEST_TARGET): $(TEST_SOURCES)
	[ -d "$(TEST_CLASSES_DIR)" ] || "$(MKDIR)" -p "$(TEST_CLASSES_DIR)"
	@$(ECHO) $(SCALAC_FLAGS) -classpath "$(TEST_CPATH)" -d "$(TEST_CLASSES_DIR)" > "$(TEST_OPTS_FILE)"
	@$(ECHO) $(TEST_SOURCES) > "$(TEST_SOURCES_FILE)"
	"$(SCALAC)" "@$(TEST_OPTS_FILE)" "@$(TEST_SOURCES_FILE)"
	@$(TOUCH) "$(TEST_TARGET)"

test: build $(TEST_TARGET)
	"$(JAVA)" -classpath "$(TEST_CPATH)" org.junit.runner.JUnitCore $(TEST_MAIN_CLASS)

##############################################################################
## phony

.PHONY: all build clean doc help lint run test

.SUFFIXES:
.SUFFIXES: .class .jar .java .scala .tasty
