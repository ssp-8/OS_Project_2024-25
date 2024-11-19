char *autocomplete_words[50] = {
    "hello", "world", "example", "system", "function", "process", "command", "terminal", 
    "keyboard", "display", "program", "error", "message", "input", "output", "file", 
    "directory", "network", "memory", "control", "action", "window", "mouse", "data", 
    "program", "execute", "script", "task", "initialize", "load", "save", "update", 
    "restart", "shutdown", "pause", "continue", "start", "stop", "navigate", "search", 
    "create", "delete", "move", "copy", "paste", "cut", "help", "config", "option", "user"
};

int rotor_offsets [] = {0,0,0};

char* rotorI = "EKMFLGDQVZNTOWYHXUSPAIBRCJ";
char* rotorII  = "AJDKSIRUXBLHWTMCQGZNPYFVOE";
char* rotorIII = "YRUHQSLDPXNGOKMIEBFZCWVJAT";

char* reflector  = "BDFHJLCPRTXVZNYEIWGAKMUSQO";
char* plugboard  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

char apply_rotor(char c, char rotor [],int offset){

    int index = (c - 'A' + offset) % 26;
    return rotor[index];
}

char apply_reflector(char c){
    return reflector[c-'A'];
}

char enigma(char c){

    c = plugboard[c-'A'];

    c = apply_rotor(c,rotorI,rotor_offsets[0]);
    c = apply_rotor(c,rotorII,rotor_offsets[1]);
    c = apply_rotor(c,rotorIII,rotor_offsets[2]);

    c = apply_reflector(c);

    c = apply_rotor(c,rotorIII,-rotor_offsets[2]);
    c = apply_rotor(c,rotorII,-rotor_offsets[1]);
    c = apply_rotor(c,rotorI,-rotor_offsets[0]);

    rotor_offsets[0]++;
    if(rotor_offsets[0] >= 26){
        rotor_offsets[0] = 0;
        rotor_offsets[1]++;
        if(rotor_offsets[1] >= 26){
            rotor_offsets[1] = 0;
            rotor_offsets[2]++;
        }
    }
    return c;
}

