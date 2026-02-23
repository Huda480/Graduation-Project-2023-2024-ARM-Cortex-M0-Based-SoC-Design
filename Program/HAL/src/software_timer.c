#include "../include/software_timer.h"

void add_timer (Timer** head,int period , timer_id ID,void (*func_ptr)){
    //Allocate new memory
    Timer* new_node = malloc(sizeof(Timer));
    //Check if memory has been allocated
    if(new_node == NULL){
        printf("Memory hasn't been allocated for new node");
        return;
    }

    //Give new node user values
    new_node -> next = NULL;
    new_node -> period = period;
    new_node -> ID = ID;
    new_node -> callback_ptr = func_ptr;
    //Check if there is a timer present
    if (*head == NULL) {
        *head = new_node;
        return;
    }

    Timer* current = *head ;
    
    //Check if ID is present
    if(current -> ID == ID){
            printf("The timer ID is already present\n");
            return;
        }

    //Check if ID is present and traverse linked list
    while (current -> next !=NULL){
        current = current -> next;
        if(current -> ID == ID){
            printf("The timer ID is already present\n");
            return;
        }
    }
   current -> next = new_node;
}

void update_timer(Timer** head) {
    if (*head == NULL) {
        return;
    }

    Timer* current = *head;
    Timer* prev = NULL;
    Timer* temp;

    while (current != NULL) {
        current->period--;

        if (current->period == 0) {
            current->callback_ptr();

            if (prev == NULL) { // If current is the head node
                *head = current->next;
                temp = current;
                current = current->next;
                free(temp);
            } else {
                prev->next = current->next;
                temp = current;
                current = current->next;
                free(temp);
            }
        } else {
            prev = current;
            current = current->next;
        }
    }
}


void print_node( Timer* root) {
   
    Timer* current = root;
    
    while (current != NULL) {
       
        printf("This node contains the vlaue %d \n ", current->period);
        current = current -> next;
    }
    
    printf("NULL\n");
}

//void func1 (void){printf("Test 1\n");}
//void func2 (void){printf("Test 2\n");}
//void func3 (void){printf("Test 3\n");}
//void func4 (void){printf("Test 4\n");}
//void func5 (void){printf("Test 5\n");}
//void func6 (void){printf("Test 6\n");}


/*int main (){
    timer_id my_timer = timer1;
    Timer *software_timer = NULL;

    add_timer(&software_timer,10,my_timer,&func1);
    
    my_timer = timer2;
    add_timer(&software_timer,6,my_timer,&func2);
    
    my_timer = timer3;
    add_timer(&software_timer,12,my_timer,&func3);
    
    my_timer = timer2;
    add_timer(&software_timer,10,my_timer,&func2);
    
    my_timer = timer4;
    print_node(software_timer); 
    add_timer(&software_timer,6,my_timer,&func4);
    
    update_timer(&software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);
    print_node(software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);
    print_node(software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);
    update_timer(&software_timer);

    return 0;
}*/
