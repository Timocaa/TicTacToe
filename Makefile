MAKEFLAGS = --no-print-directory

#=================================COMPILATION==================================#
CC = g++
CPPFLAGS = -g -Wall -Werror -Wextra
LIBFSMLFLAG = -L SFML_linux/lib -lsfml-graphics -lsfml-window -lsfml-system
LIBFSMLFLAGWINDOWS = -L SFML_windows/lib -lsfml-graphics -lsfml-window -lsfml-system

#==================================EXECUTABLE==================================#
NAME = TicTacToe
EXEC_DIR_LINUX = linux_executable/
EXEC_LINUX = $(EXEC_DIR_LINUX)$(NAME)

EXEC_DIR_WINDOWS = windows_executable/
EXEC_WINDOWS = $(EXEC_DIR_WINDOWS)$(NAME).exe

#===================================INCLUDES===================================#
INCLUDES = -I SFML_linux/include -I includes

#=================================SOURCE FILES=================================#
SRCS =	src/main.cpp

#====================================OBJECTS===================================#
OBJS = ${SRCS:.cpp=.o}

#====================================COLORS====================================#
NOC			= \033[0m
BOLD		= \033[1m
UNDERLINE	= \033[4m
BLINK		= \e[5m
BLACK		= \033[1;30m
RED			= \e[1m;31m;
GREEN		= \e[1m;32m;
YELLOW		= \e[1m;33m;
RED			= \e[1m\e[38;5;196m
GREEN		= \e[1m\e[38;5;76m
YELLOW		= \e[1m\e[38;5;220m
BLUE		= \e[1m\e[38;5;33m
VIOLET		= \033[1;35m
CYAN		= \033[1;36m
WHITE		= \033[1;37m

#==============================PROGRESS BAR UTILS==============================#
PERCENT = 0
NB_COMPIL = 0
TOTAL_COMPIL = $(words $(OBJS))
PROGRESS_BAR_DETAIL = 5

#=====================================RULES====================================#
%.o : %.cpp
	$(if $(filter $(NB_COMPIL),0), @echo "$(BLUE)Compiling$(NOC)")
	$(if $(filter $(NB_COMPIL),0), @echo "$(YELLOW)$(NB_COMPIL) 0%$(NOC)")
	$(if $(filter $(NB_COMPIL),0), @make create_progressbar)
	$(if $(filter $(NB_COMPIL),0), @@./.progressbar 0)
	$(eval NB_COMPIL=$(shell echo $$(($(NB_COMPIL)+1))))
	$(eval PERCENT=$(shell echo $$(($(NB_COMPIL) * 100 / $(TOTAL_COMPIL)))))
	@$(CC) $(CPPFLAGS) $(INCLUDES) -c $< -o $@
	@./.progressbar $(PERCENT)

$(EXEC_LINUX): $(OBJS)
	@./.progressbar 100
	@rm .progressbar
	@echo "$(BLUE)Creation of binary$(NOC)"
	@mkdir $(EXEC_DIR_LINUX) 2>/dev/null || echo -n
	@g++ $^ $(LIBFSMLFLAG) -o $(EXEC_LINUX)
	@echo "$(GREEN)Done$(NOC)"

all : $(EXEC_LINUX)

clean :
	@echo "$(RED)Deleting objects$(NOC)"
	@rm -f $(OBJS)

fclean : clean
	@echo "$(RED)Deleting binary$(NOC)"
	@rm -f $(EXEC_LINUX)
	@rmdir $(EXEC_DIR_LINUX) 2>/dev/null || echo -n

re :
	@clear
	@make fclean
	@make $(EXEC_LINUX)

run: $(EXEC_LINUX)
	@echo "$(BLUE)Launch game$(NOC)"
	@export LD_LIBRARY_PATH=SFML_linux/lib/ && $(EXEC_LINUX)
	@echo "$(GREEN)Have a nice day :)$(NOC)"

create_progressbar:
	@echo '#include <stdio.h>' > .progressbar.cpp
	@echo '#include <stdlib.h>\n' >> .progressbar.cpp
	@echo 'void	print_color(int color)' >> .progressbar.cpp
	@echo '{' >> .progressbar.cpp
	@echo '	if (color == -1)' >> .progressbar.cpp
	@echo '		printf("\\e[0m ");' >> .progressbar.cpp
	@echo '	else if (color == 0)' >> .progressbar.cpp
	@echo '		printf("\\e[48;5;154m ");' >> .progressbar.cpp
	@echo '	else if (color == 1 || color == 9)' >> .progressbar.cpp
	@echo '		printf("\\e[48;5;155m ");' >> .progressbar.cpp
	@echo '	else if (color == 2 || color == 8)' >> .progressbar.cpp
	@echo '		printf("\\e[48;5;156m ");' >> .progressbar.cpp
	@echo '	else if (color == 3 || color == 7)' >> .progressbar.cpp
	@echo '		printf("\\e[48;5;157m ");' >> .progressbar.cpp
	@echo '	else if (color == 4 || color == 6)' >> .progressbar.cpp
	@echo '		printf("\\e[48;5;158m ");' >> .progressbar.cpp
	@echo '	else if (color == 5)' >> .progressbar.cpp
	@echo '		printf("\\e[48;5;159m ");' >> .progressbar.cpp
	@echo '}\n' >> .progressbar.cpp
	@echo 'int	main(int ac, char **av)' >> .progressbar.cpp
	@echo '{' >> .progressbar.cpp
	@echo '	int	nb = atoi(av[1]);\n' >> .progressbar.cpp
	@echo '	printf("\\e[1A\\e[K");' >> .progressbar.cpp
	@echo '	for (int i = 0; i <= 100; i += $(PROGRESS_BAR_DETAIL))' >> .progressbar.cpp
	@echo '	{' >> .progressbar.cpp
	@echo '		if (i > nb)' >> .progressbar.cpp
	@echo '			printf("\\e[48;5;196m ");' >> .progressbar.cpp
	@echo '		else' >> .progressbar.cpp
	@echo '			print_color((nb - (i / $(PROGRESS_BAR_DETAIL))) % 10);' >> .progressbar.cpp
	@echo '	}' >> .progressbar.cpp
	@echo '	print_color(-1);' >> .progressbar.cpp
	@echo '	if (nb == 100)' >> .progressbar.cpp
	@echo '		printf("\e[1m\e[38;5;76m100%%\\e[0m\\n");' >> .progressbar.cpp
	@echo '	else' >> .progressbar.cpp
	@echo '		printf("\e[1m\e[38;5;220m%i%%\\e[0m\\n", nb);' >> .progressbar.cpp
	@echo '}' >> .progressbar.cpp
	@$(CC) .progressbar.cpp -o .progressbar
	@rm .progressbar.cpp

win :
	g++ -static $(SRCS) $(INCLUDES) $(LIBFSMLFLAGWINDOWS) -o $(EXEC_WINDOWS)

winrun :
	$(EXEC_WINDOWS)

linux-win :
	x86_64-w64-mingw32-g++ -static $(SRCS) $(INCLUDES) $(LIBFSMLFLAGWINDOWS) -o $(EXEC_WINDOWS)

.PHONY: all clean fclean re run create_progressbar
