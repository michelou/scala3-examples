ifndef JAVA_HOME
$(error Variable JAVA_HOME is not set)
endif
ifndef MAVEN_HOME
$(error Variable MAVEN_HOME is not set)
endif
ifndef SCALA3_HOME
$(error Variable SCALA3_HOME is not set)
endif

ifeq ($(OS),Windows_NT)
JAR        = $(subst \,/,$(JAVA_HOME))/bin/jar.exe
JAVA       = $(subst \,/,$(JAVA_HOME))/bin/java.exe
JAVAC      = $(subst \,/,$(JAVA_HOME))/bin/javac.exe
MVN        = $(subst \,/,$(MAVEN_HOME))/bin/mvn.cmd
SCALA      = $(subst \,/,$(SCALA3_HOME))/bin/scala.bat
SCALAC     = $(subst \,/,$(SCALA3_HOME))/bin/scalac.bat
SCALADOC   = $(subst \,/,$(SCALA3_HOME))/bin/scaladoc.bat
SCALAFMT   = $(subst \,/,$(LOCALAPPDATA))/Coursier/data/bin/scalafmt.bat
LOCAL_REPO = $(subst \,/,$(USERPROFILE))/.m2/repository
PSEP       = ;
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CP         = /usr/bin/cp.exe
ECHO       = /usr/bin/echo.exe
FIND       = /usr/bin/find.exe
MKDIR      = /usr/bin/mkdir.exe
RM         = /usr/bin/rm.exe
TOUCH      = /usr/bin/touch.exe
WGET       = /usr/bin/wget
else
JAR        = $(JAVA_HOME)/bin/jar
JAVA       = $(JAVA_HOME)/bin/java
JAVAC      = $(JAVA_HOME)/bin/javac
SCALA      = $(SCALA3_HOME)/bin/scala
SCALAC     = $(SCALA3_HOME)/bin/scalac
SCALADOC   = $(SCALA3_HOME)/bin/scaladoc
SCALAFMT   = $(HOME)/.local/share/coursier/bin/scalafmt
LOCAL_REPO = $(HOME)/.m2/repository
PSEP       = :
CP         = cp
ECHO       = echo
FIND       = find
MKDIR      = mkdir
MVN        = mvn
RM         = rm
TOUCH      = touch
WGET       = wget
endif

## https://mvnrepository.com/artifact/org.hamcrest/hamcrest
HAMCREST_VERSION = 3.0
## https://mvnrepository.com/artifact/org.hamcrest/hamcrest-all
HAMCREST_ALL_VERSION = 1.3
## https://mvnrepository.com/artifact/junit/junit
JUNIT_VERSION = 4.13.2
## https://mvnrepository.com/artifact/org.scala-lang/scala-library
SCALA_VERSION = 2.13.17
## https://mvnrepository.com/artifact/org.scala-lang/scala3-library
SCALA3_VERSION = 3.3.7
## https://mvnrepository.com/artifact/org.scalatest/scalatest
SCALATEST_VERSION = 3.2.19
## https://mvnrepository.com/artifact/org.specs2/specs2-core
## Note: Specs2 5.x depends on Scala 3 while Specs2 4.x depends on Scala 2 or Scala 3
SPECS2_VERSION = 5.6.4

SCALA_LIB_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/scala-lang" -name "scala-library-$(SCALA_VERSION).jar" | tail -1)
SCALA3_LIB_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/org/scala-lang" -name "scala3-library_3-$(SCALA3_VERSION).jar" | tail -1)

HAMCREST_JAR          = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name "hamcrest-$(HAMCREST_VERSION).jar")
HAMCREST_ALL_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/hamcrest" -name "hamcrest-all-$(HAMCREST_ALL_VERSION).jar")
JUNIT_JAR             = $(shell $(FIND) "$(LOCAL_REPO)/junit/junit" -name "junit-$(JUNIT_VERSION).jar")
JUNIT_INTF_JAR        = $(shell $(FIND) "$(LOCAL_REPO)/com/novocode" -name "junit-interface-0.11.jar")

SCALATEST_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/scalatest" -name "scalatest_3-$(SCALATEST_VERSION).jar")
SCALATEST_FUNSPEC_JAR = $(shell $(FIND) "$(LOCAL_REPO)/org/scalatest" -name "scalatest-funspec_3-$(SCALATEST_VERSION).jar")
SCALACTIC_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/scalactic" -name "scalactic_3-$(SCALATEST_VERSION).jar")

SPECS2_COMMON_JAR     = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name "specs2-common_3-$(SPECS2_VERSION).jar")
SPECS2_CORE_JAR       = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name "specs2-core_3-$(SPECS2_VERSION).jar")
SPECS2_FP_JAR         = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name "specs2-fp_3-$(SPECS2_VERSION).jar")
SPECS2_JUNIT_JAR      = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name "specs2-junit_3-$(SPECS2_VERSION).jar")
SPECS2_MATCHER_JAR    = $(shell $(FIND) "$(LOCAL_REPO)/org/specs2" -name "specs2-matcher_3-$(SPECS2_VERSION).jar")

deps:
	$(eval MVN_OPTS := -quiet)
	$(eval REMOTE_REPO := https://repo1.maven.org/maven2)
	$(eval WGET_OPTS := --user-agent="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:40.0)" --no-check-certificate --directory-prefix="$(TMP)")
	@$(ECHO) "## Check Maven dependencies on $(REMOTE_REPO)"
ifeq (,$(wildcard $(SCALA_LIB_JAR)))
	$(eval GROUP_ID := org.scala-lang)
	$(eval ARTIFACT_ID := scala-library)
	$(eval VERSION := $(SCALA_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval SCALA_LIB_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(SCALA3_LIB_JAR)))
	$(eval GROUP_ID := org.scala-lang)
	$(eval ARTIFACT_ID := scala3-library_3)
	$(eval VERSION := $(SCALA3_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval SCALA3_LIB_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(HAMCREST_JAR)))
	$(eval GROUP_ID := org/hamcrest)
	$(eval ARTIFACT_ID := hamcrest)
	$(eval VERSION := $(HAMCREST_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval HAMCREST_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(HAMCREST_ALL_JAR)))
	$(eval GROUP_ID := org/hamcrest)
	$(eval ARTIFACT_ID := hamcrest-all)
	$(eval VERSION := $(HAMCREST_ALL_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval HAMCREST_ALL_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(JUNIT_JAR)))
	$(eval GROUP_ID := junit)
	$(eval ARTIFACT_ID := junit)
	$(eval VERSION := $(JUNIT_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval JUNIT_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(SCALATEST_JAR)))
	$(eval GROUP_ID := org.scalatest)
	$(eval ARTIFACT_ID := scalatest_3)
	$(eval VERSION := $(SCALATEST_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval SCALATEST_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(SCALATEST_FUNSPEC_JAR)))
	$(eval GROUP_ID := org.scalatest)
	$(eval ARTIFACT_ID := scalatest-funspec_3)
	$(eval VERSION := $(SCALATEST_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval SCALATEST_FUNSPEC_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(SCALACTIC_JAR)))
	$(eval GROUP_ID := org.scalactic)
	$(eval ARTIFACT_ID := scalactic_3)
	$(eval VERSION := $(SCALATEST_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval SCALACTIC_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(SPECS2_COMMON_JAR)))
	$(eval GROUP_ID := org.specs2)
	$(eval ARTIFACT_ID := specs2-common_3)
    $(eval VERSION := $(SPECS2_VERSION))
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(VERSION)/$(ARTIFACT_ID)-$(VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(VERSION) -Dpackaging=jar
	$(eval SPECS2_COMMON_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(VERSION).jar))
endif
ifeq (,$(wildcard $(SPECS2_CORE_JAR)))
	$(eval GROUP_ID := org.specs2)
	$(eval ARTIFACT_ID := specs2-core_3)
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(SPECS2_VERSION)/$(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(SPECS2_VERSION) -Dpackaging=jar
	$(eval SPECS2_CORE_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(SPECS2_VERSION).jar))
endif
ifeq (,$(wildcard $(SPECS2_JUNIT_JAR)))
	$(eval GROUP_ID := org.specs2)
	$(eval ARTIFACT_ID := specs2-junit_3)
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(SPECS2_VERSION)/$(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(SPECS2_VERSION) -Dpackaging=jar
	$(eval SPECS2_JUNIT_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(SPECS2_VERSION).jar))
endif
ifeq (,$(wildcard $(SPECS2_MATCHER_JAR)))
	$(eval GROUP_ID := org.specs2)
	$(eval ARTIFACT_ID := specs2-matcher_3)
	$(eval JAR_FILE := $(TMP)/$(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(eval URL := $(REMOTE_REPO)/$(subst .,/,$(GROUP_ID))/$(ARTIFACT_ID)/$(SPECS2_VERSION)/$(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(WGET) $(WGET_OPTS) $(URL) || $(error Failed to download $(ARTIFACT_ID)-$(SPECS2_VERSION).jar)
	$(MVN) $(MVN_OPTS) install:install-file -Dfile="$(JAR_FILE)" -DgroupId=$(GROUP_ID) -DartifactId=$(ARTIFACT_ID) -Dversion=$(SPECS2_VERSION) -Dpackaging=jar
	$(eval SPECS2_MATCHER_JAR := $(shell $(FIND) "$(LOCAL_REPO)/$(subst .,/,$(GROUP_ID))" -name $(ARTIFACT_ID)-$(SPECS2_VERSION).jar))
endif
