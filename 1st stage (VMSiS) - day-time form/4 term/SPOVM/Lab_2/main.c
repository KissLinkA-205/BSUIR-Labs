#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <limits.h>
 
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>

unsigned directory_browsing( char *introducedDir, char *option, int fl )
{
    DIR *dir = NULL;
    struct dirent *entry = NULL;
    char pathName[PATH_MAX + 1];
    dir = opendir(introducedDir);
    if( dir == NULL ) {
    	printf( "Error opening %s: %s", introducedDir, strerror(errno));
    	return 0;
    }
	entry = readdir(dir);
	while(entry != NULL) {
    	struct stat entryInfo;
    	if((strncmp(entry->d_name, ".", PATH_MAX) == 0) || (strncmp(entry->d_name, "..", PATH_MAX) == 0)) {
        	entry = readdir(dir);
        	continue;
    	}
	    (void)strncpy(pathName, introducedDir, PATH_MAX);
        (void)strncat(pathName, "/", PATH_MAX);
        (void)strncat(pathName, entry->d_name, PATH_MAX);
        if(lstat(pathName, &entryInfo) == 0) {
            if(S_ISDIR(entryInfo.st_mode)) {
			    if(strstr(option, "d") != NULL || fl == 1) {            
            		printf("\t-d %s\n", pathName);
			    }
                directory_browsing(pathName, option, fl);
            } 
		    else if(S_ISREG(entryInfo.st_mode)) { 
			    if(strstr(option, "f") != NULL || fl == 1) {            
            		printf("\t-f %s has %lld bytes\n", pathName, (long long)entryInfo.st_size);
			    }
            } 
		    else if(S_ISLNK(entryInfo.st_mode)) { 
                char targetName[PATH_MAX + 1];
                if(readlink(pathName, targetName, PATH_MAX) != -1) {
				    if(strstr(option, "l") != NULL || fl == 1) {            
            			printf("\t-l %s -> %s\n", pathName, targetName);
				    }
                } 
			else {
				if(strstr(option, "l") != NULL || fl == 1) {            
            				printf("\t%s -> (invalid symbolic link!)\n", pathName);
				    }
                }
            }
        }    
	    else {
            printf("Error statting %s: %s\n", pathName, strerror(errno));
        }
 	    entry = readdir(dir);
	}
	(void)closedir(dir);
	return 0;
}

int main(int argc, char **argv)
{
	char option[PATH_MAX];
	char direct[PATH_MAX];
	int fl;
	if(argc == 3) {
		strncpy(option, argv[2], PATH_MAX);
		strcpy(direct, argv[1]);
		fl = 0;
	}
	if(argc == 1) { 
		strcpy(direct,".");
		fl = 1;
	}
	if(argc == 2) {
		if(strstr(argv[1], "-f") != NULL || strstr(argv[1], "-d") != NULL || strstr(argv[1], "-l") != NULL) { 
			strncpy(option, argv[1], PATH_MAX);
			strcpy(direct,".");
			fl = 0;
		}
		else {
			strcpy(direct, argv[1]);
			fl = 1;
		}
	}	
    directory_browsing(direct, option, fl );
    return EXIT_SUCCESS;
}
