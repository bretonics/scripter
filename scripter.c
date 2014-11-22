//
//  scripter.c
//  
//
//  Created by Andres Breton on 9/30/14.
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc, char *argv[]) {
    
    //VARIABLES
    
    char fileType[10];
    char fileName[250];
    char createPerl[500];
    char createRuby[500];
    char createPython[500];
    FILE *file;
    
    
    sprintf(fileType, "%s", argv[1]);
    sprintf(fileName, "%s", argv[2]);
    
    sprintf(createPerl, "touch %s; chmod 751 %s", fileName, fileName);
    
    sprintf(createRuby, "touch %s; chmod 751 %s", fileName, fileName );
    
    sprintf(createPython, "touch %s; chmod 751 %s", fileName, fileName );
    
    
    //CHECKS
    
    if (argc < 3) {
        fprintf(stderr, "\n[ERROR]: Please provide the type of file, i.e) perl, ruby, python and file name.");
        printf("\nThis program is designed to help outmate Perl, Ruby, and Python script template creation.\n\n");
        return 0;
    }
    
//    printf("FIle type is %s", fileType);
    
//    if ( (strncmp(fileType, "ruby", 4) != 0) || (strncmp(fileType, "ruby", 4) != 0)  ||(strncmp(fileType, "python", 6) != 0) ) {
//        printf("\nYour file type \"%s\" is not valid. Please provide \"perl\", \"ruby\", or \"python\"\n\n", fileType);
//        return 0;
//    }

    
    //CREATE FILE
    
    if (strncmp(fileType, "perl", 4) == 0 ) {
        system(createPerl);
        file = fopen(fileName, "w");
            fprintf(file, "#!/usr/bin/perl \n\nuse warnings;\nuse strict;\nuse diagnostics;\nuse feature qw(say);\n\n#####################\n#\n# 	Created by: \n#	File:\n#\n#####################\n\n");
        fclose(file);
        
        if (fileName == NULL) {
            printf("Could not open/find file %s", fileName);
            return 0;
        } else {
            printf("\nFile %s sucessfully created\n\n", fileName);
        }
    }

    if (strncmp(fileType, "ruby", 4) == 0 ) {
        system(createRuby);
        file = fopen(fileName, "w");
            fprintf(file, "#!/usr/bin/ruby\n\n#####################\n#\n# 	Created by: \n#	File:\n#\n#####################\n\n");
        fclose(file);
        
        if (fileName == NULL) {
            printf("Could not open/find file %s", fileName);
            return 0;
        } else {
            printf("\nFile %s sucessfully created\n\n", fileName);
        }
    }

    if (strncmp(fileType, "python", 6) == 0 ) {
        system(createPython);
        file = fopen(fileName, "w");
            fprintf(file, "#!/usr/bin/python\n\nimport sys\n\n#####################\n#\n# 	Created by: \n#	File:\n#\n#####################\n\n");
        fclose(file);
        
        if (fileName == NULL) {
            printf("Could not open/find file %s", fileName);
            return 0;
        } else {
            printf("\nFile %s sucessfully created\n\n", fileName);
        }
    }
    
    return 0;
}