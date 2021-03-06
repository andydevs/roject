# -------------------------------- CONFIG --------------------------------

TARGET = foo

SHELL = /bin/bash -O globstar
CC    = g++

COMPILE = $(CC) -c
LINK    = $(CC)

CFLAGS = -Wall -std=c++14
LFLAGS = -Wall
INCLUD = -Iinclude
LIBRAR = -Llib

# -------------------------------- FOLDER --------------------------------

INCDIR = include
SRCDIR = src
OBJDIR = obj
BINDIR = bin
INSDIR = /usr/bin

# -------------------------------- FILES  --------------------------------

INCLUDS = $(shell ls $(INCDIR)/**/*.h)
SOURCES = $(shell ls $(SRCDIR)/**/*.cpp)
OBJECTS = $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SOURCES))
BINARY  = $(BINDIR)/$(TARGET)

# -------------------------------- TASKS  --------------------------------

$(BINARY): $(OBJECTS)
	@echo $(SOURCES)
	@test -d $(@D) || mkdir $(@D)
	@echo building $@
	@$(LINK) $^ -o $@ $(LFLAGS) $(LIBRAR)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(INCLUDS)
	@test -d $(@D) || mkdir $(@D)
	@echo compiling $<
	@$(COMPILE) $< -o $@ $(CPPFLAGS) $(INCLUD)

clean:
	@echo Cleaning up...
	@rm -r $(OBJDIR) $(BINDIR)

install:
	cp $(BINDIR)/$(TARGET) $(INSDIR)

uninstall:
	rm $(INSDIR)/$(TARGET)

run:
	$(BINARY)