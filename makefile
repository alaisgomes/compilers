
CC		= gcc
NAME		= html

.QUIET:

all:		 	$(NAME)

$(NAME):		$(NAME).h $(NAME).l $(NAME).y
				bison $(NAME).y
				flex $(NAME).l
				$(CC) -s -O $(NAME).tab.c -lm -o $(NAME)

clean:
				-@rm lex.yy.c y.output* y.tab.c y.tab.h html
