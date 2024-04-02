#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<dirent.h>
#include<unistd.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<sys/wait.h>

int global;

int main(int argc, char *argv[]){
    int local = 0; 
    char path[500];

    if (argc != 2) {
        printf("Invalid number of arguments./n");
        return -1;
    }

    DIR *directory = opendir(argv[1]);
    if (directory == NULL) {
        printf("Invalid path. Using current directory instead.\n");
        closedir(directory);
        getcwd(path, 200);
        directory = opendir(path);
    }
    else {
        strcpy(path, argv[1]);
    }
    printf("Directory path: %s\n", path);

    pid_t parent_pid, child_pid;
    parent_pid = getpid();
    child_pid = fork();

    if (child_pid > 0) {
        printf("parent process\n");
        printf("parent pid = %d, child pid = %d\n", (int) parent_pid, (int) child_pid);
        int child_status;
        waitpid(child_pid, &child_status, 0);
        printf("Child exit code: %d\n", child_status);
        printf("Parent's local = %d, parent's global = %d\n", local, global);
        return 1;
    }
    else if (child_pid == 0) {
        printf("child process\n");
        local++;
        global++;
        printf("child pid = %d, parent pid = %d\n", (int) getpid(), (int) parent_pid);
        printf("Child's local = %d, childs's global = %d\n", local, global);
        int ls_status = execl("/bin/ls", "ls", path, (char*) NULL);
        return ls_status;
    }
    else {
        printf("Creation of child process was unsuccessful.\n");
    }

    closedir(directory);
    return 1;
}