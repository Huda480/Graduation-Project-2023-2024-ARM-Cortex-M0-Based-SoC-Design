#include <stdio.h>
#include <stdlib.h>

typedef struct Node{
    int x ;
   struct Node* next ;
} Node ;


Node* linked_list_create(int value) {
    Node* new_Node = malloc(sizeof(Node));
    if(new_Node == NULL){
        printf("Memory hasn't been allocated for new node");
        return NULL;
    }
    new_Node->x = value;
    new_Node->next = NULL;
    return new_Node;
}

void insert_node_at_tail (Node** root,int value){
    Node* new_Node = malloc(sizeof(Node));

    if(new_Node == NULL){
        printf("Memory hasn't been allocated for new node");
        return;
    }


    new_Node -> next = NULL;
    new_Node -> x = value ;

    if (*root == NULL) {
        *root = new_Node;
        return;
    }

    Node* current = *root ;
    while (current -> next !=NULL){
        current = current -> next ;
    }

   current -> next = new_Node;


}


void insert_node_at_head (Node** root,int value){
    Node* new_Node = malloc(sizeof(Node));

    if(new_Node == NULL){
        printf("Memory hasn't been allocated for new node");
        return;
    }

    new_Node -> x = value ;
    new_Node -> next = *root ;

    *root = new_Node ;
}



void insert_node_at_pos(Node** root, int position, int value) {
    Node* new_Node = malloc(sizeof(Node));
    if (new_Node == NULL) {
        printf("Memory hasn't been allocated for new node");
        return;
    }
    new_Node->x = value;
    new_Node->next = NULL;
    if (*root == NULL) {
        if (position != 0) {
            return;
        } else { 
            *root = new_Node;
        }
    }
    if (*root != NULL && position == 0) {
        new_Node->next= *root;
        *root = new_Node;
        return;
    }
    Node* current = *root;
    Node* previous = NULL;
    int i = 0;
    while (i < position) {
        previous = current;
        current = current->next;
        if (current == NULL) {
            break;
        }
        i++;
    }
    new_Node->next = current;
    previous->next = new_Node;
}

void sort_descending(Node** head_ref) {
    struct Node* sorted = NULL;
    struct Node* current = *head_ref;

    while (current != NULL) {
        struct Node* next = current->next;

        // Insert current into sorted list
        struct Node** prev = &sorted;
        while (*prev != NULL && (*prev)->x > current->x) {
            prev = &((*prev)->next);
        }
        current->next = *prev;
        *prev = current;

        current = next;
    }

    *head_ref=sorted;
}

void sort_ascending(Node** head_ref) {
    struct Node* sorted = NULL;
    struct Node* current = *head_ref;

    while (current != NULL) {
        struct Node* next = current->next;

        // Insert current into sorted list
        struct Node** prev = &sorted;
        while (*prev != NULL && (*prev)->x < current->x) {
            prev = &((*prev)->next);
        }
        current->next = *prev;
        *prev = current;

        current = next;
    }

    *head_ref=sorted;
}

void remove_node_by_value (Node** root , int value){
    if(*root == NULL){
    return;
    }

    if((*root) -> x == value){
        Node* remove_this_node = *root ;
        *root = (*root) -> next ;
        free (remove_this_node);
        return;
    }

    for(Node* current = *root ; current -> next != NULL ; current = current -> next) {
        if(current -> next -> x == value) {
            Node* remove_this_node = current -> next ;
            current -> next = current -> next -> next ;
            free (remove_this_node);
            return;
        }
    }

}

int getCurrSize (struct Node *node)
{
  int size = 0;

  while (node != NULL)
    {
      node = node->next;
      size++;
    }
  return size;
}

void remove_node_by_Position (Node** head, int n)
{
  Node *temp = *head;
  Node *previous;
  //if the head node itself needs to be deleted
  int size = getCurrSize (*head);
  // not valid
  if (n < 0 || n > size)
    {
      printf ("Enter valid position\n");
      return;
    }
  // delete the first node
  if (n == 0)
    {
      // move head to next node
      *head = (*head)->next;
      free (temp);
      return;
    }
  // traverse to the nth node
  while (n--)
    {
      // store previous link node as we need to change its next val
      previous = temp;
      temp = temp->next;
    }
  // change previous node's next node to nth node's next node
  previous->next = temp->next;
  printf ("Deleted the node with value: %d\n", temp->x);
  // delete this nth node
  free (temp);
}


void subtract_tail (Node** root){
    //Check if the linked list contains more than one element to subtract
    if(*root == NULL){
        printf("The linked list is empty no values to subtract");
        return;
    }
    if((*root)-> next == NULL){
        printf("The root node is the only node in the linked list");
        return;
    }
    Node* current = *root;
    Node* previous = NULL;
    //Traverse the entire linked list
    while(current -> next != NULL){
        previous = current;
        current = current -> next;
    }
    //Value to subtract from all nodes
    int tail = current -> x;

    //Re-initialize the current pointer to the beggining of the linked list
    current = *root;
    while(current != NULL){
        if(current -> x != tail){
            current ->x -= tail;
        }
        current =current ->next; 
    }
    free(previous ->next);
    //previous -> next = NULL;
}

void subtract_head (Node** root){
    //Check if the linked list contains more than one element to subtract
    if(*root == NULL){
        printf("The linked list is empty no values to subtract");
        return;
    }
    if((*root)-> next == NULL){
        printf("The root node is the only node in the linked list");
        free(*root);
        *root = NULL;
        return;
    }
    Node* current = *root;
    //Value to subtract from all nodes
    int head = current -> x;
    while(current != NULL){
        if(current -> x != head){
            current ->x -= head;
        }
        current =current ->next; 
    }
    Node* destroy = *root;
    *root = (*root)->next;
    free(destroy);
}

void Print_Node( Node* root) {
   
    Node* current = root;
    
    while (current != NULL) {
       
        printf("This node contains the vlaue %d \n ", current->x);
        current = current -> next;
    }
    
    printf("NULL\n");
}

void deallocate (Node** root){
    Node* curr = *root;
    while (curr != NULL){
        Node* destroy = curr;
        curr = curr ->next;
        free(destroy);
    }
    *root = NULL;
}


/*int main () {
    Node* root = linked_list_create(9); 

    
    insert_node_at_tail(&root, 12);
    insert_node_at_tail(&root, 3);
    insert_node_at_tail(&root, 2);
    insert_node_at_tail(&root, 21);
    printf("List after inserting nodes at the tail:\n");
    Print_Node(root);

    printf("List after sorting elements in descending order nodes at the tail:\n");
    sort_descending(&root);
    Print_Node(root);

    printf("List after sorting elements in ascending order nodes at the tail:\n");
    sort_ascending(&root);
    Print_Node(root);

    printf("List after subtracting the head element:\n");
    subtract_head(&root);
    Print_Node(root);

    printf("List after subtracting the tail value:\n");
    subtract_tail(&root);
    Print_Node(root);


    
    insert_node_at_head(&root, 0);
    printf("\nList after inserting a node at the head:\n");
    Print_Node(root);

    
    insert_node_at_pos(&root, 3, 5);
    printf("\nList after inserting a node at a specific position:\n");
    Print_Node(root);

    
    insert_node_at_pos(&root, 0, 8);
    printf("\nList after inserting a node at a specific position:\n");
    Print_Node(root);


    
    remove_node_by_value(&root, 2);
    printf("\nList after removing a node:\n");
    Print_Node(root);

    remove_node_by_Position(&root, 2);
    printf("\nList after removing a node:\n");
    Print_Node(root);

    printf("List after destroying linked list \n");
    deallocate(&root);
    Print_Node(root);

    return 0;

}*/




