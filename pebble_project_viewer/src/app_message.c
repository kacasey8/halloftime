#include <pebble.h>

#define NUM_MENU_SECTIONS 1
    
int num_first_menu_items = 1;

int number_of_projects_received = 0;
    
Window *window; 

MenuLayer *menu_layer;
  
// Key values for AppMessage Dictionary
enum {
  STATUS_KEY = 0, 
  MESSAGE_KEY = 1,
    SUM_KEY = 2
};

typedef struct Project {
    char name[64];
    int sum;
    int id;
} Project;

Project project_array[64];
char sumStr[64];

// A callback is used to specify the amount of sections of menu items
// With this, you can dynamically add and remove sections
static uint16_t menu_get_num_sections_callback(MenuLayer *menu_layer, void *data) {
  return NUM_MENU_SECTIONS;
}

// Each section has a number of items;  we use a callback to specify this
// You can also dynamically add and remove items using this
static uint16_t menu_get_num_rows_callback(MenuLayer *menu_layer, uint16_t section_index, void *data) {
  switch (section_index) {
    case 0:
      return num_first_menu_items;

    default:
      return 0;
  }
}

// A callback is used to specify the height of the section header
static int16_t menu_get_header_height_callback(MenuLayer *menu_layer, uint16_t section_index, void *data) {
  // This is a define provided in pebble.h that you may use for the default height
  return MENU_CELL_BASIC_HEADER_HEIGHT;
}

// Here we draw what each header is
static void menu_draw_header_callback(GContext* ctx, const Layer *cell_layer, uint16_t section_index, void *data) {
  // Determine which section we're working with
  switch (section_index) {
    case 0:
      // Draw title text in the section header
      menu_cell_basic_header_draw(ctx, cell_layer, "Projects");
      break;
  }
}

// This is the menu item draw callback where you specify what each item should look like
static void menu_draw_row_callback(GContext* ctx, const Layer *cell_layer, MenuIndex *cell_index, void *data) {
    snprintf(sumStr, 64, "%d hr %d min", (int)project_array[cell_index->row].sum / 60, (int)project_array[cell_index->row].sum % 60);   
    if (!project_array[cell_index->row].sum) {
        snprintf(sumStr, 64, " ");
    }
    menu_cell_basic_draw(ctx, cell_layer, project_array[cell_index->row].name, sumStr, NULL);
}

// Here we capture when a user selects a menu item
void menu_select_callback(MenuLayer *menu_layer, MenuIndex *cell_index, void *data) {
  // Use the row to specify which item will receive the select action
  APP_LOG(APP_LOG_LEVEL_DEBUG, "select cell index: %d %d", (int)cell_index->section, (int)cell_index->row);
}

// Write message to buffer & send
void send_message(void){
    /*
  DictionaryIterator *iter;
  
  app_message_outbox_begin(&iter);
  dict_write_uint8(iter, STATUS_KEY, 0x1);
  dict_write_cstring(iter, MESSAGE_KEY, "Hi Phone, I'm a Pebble!");

  dict_write_end(iter);
    app_message_outbox_send();
    */
}

// Called when a message is received from PebbleKitJS
static void in_received_handler(DictionaryIterator *received, void *context) {
  Tuple *tuple;
  
    int status = 0;
    
  tuple = dict_find(received, STATUS_KEY);
  if(tuple) {
    APP_LOG(APP_LOG_LEVEL_DEBUG, "Received Status: %d", (int)tuple->value->uint32);  
      num_first_menu_items = (int)tuple->value->uint32 + 1;
        status = (int)tuple->value->uint32;
  } 
    
  tuple = dict_find(received, MESSAGE_KEY);
  if(tuple) {
     snprintf(project_array[status].name, 64, "%s", tuple->value->cstring);
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Received Message: %s", project_array[status].name);  
       
  }

    tuple = dict_find(received, SUM_KEY);
  if(tuple) {
    APP_LOG(APP_LOG_LEVEL_DEBUG, "Received Sum: %d", (int)tuple->value->uint32);  
      project_array[status].sum = (int)tuple->value->uint32;
    }
    
    //APP_LOG(APP_LOG_LEVEL_DEBUG, "Test at index %d: %s", status, project_array[status].name);
    
   layer_mark_dirty((Layer*)menu_layer);
}

// Called when an incoming message from PebbleKitJS is dropped
static void in_dropped_handler(AppMessageResult reason, void *context) {  
    snprintf(project_array[0].name, 64, "Inbound Dropped");
}

// Called when PebbleKitJS does not acknowledge receipt of a message
static void out_failed_handler(DictionaryIterator *failed, AppMessageResult reason, void *context) {
    snprintf(project_array[0].name, 64, "Outbound Dropped");
}

void tick_callback(struct tm *tick_time, TimeUnits units_changed) {
    DictionaryIterator *iter; 
    app_message_outbox_begin(&iter);
    app_message_outbox_send();
}

void window_load(Window *window) {
    // Now we prepare to initialize the menu layer
  // We need the bounds to specify the menu layer's viewport size
  // In this case, it'll be the same as the window's
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_frame(window_layer);

    snprintf(project_array[0].name, 64, "Retrieving...");
    
  // Create the menu layer
  menu_layer = menu_layer_create(bounds);

  // Set all the callbacks for the menu layer
  menu_layer_set_callbacks(menu_layer, NULL, (MenuLayerCallbacks){
    .get_num_sections = menu_get_num_sections_callback,
    .get_num_rows = menu_get_num_rows_callback,
    .get_header_height = menu_get_header_height_callback,
    .draw_header = menu_draw_header_callback,
    .draw_row = menu_draw_row_callback,
    .select_click = menu_select_callback,
  });
    
  // Bind the menu layer's click config provider to the window for interactivity
  menu_layer_set_click_config_onto_window(menu_layer, window);

  // Add it to the window for display
  layer_add_child(window_layer, menu_layer_get_layer(menu_layer));
}

void window_unload(Window *window) {
  // Destroy the menu layer
  menu_layer_destroy(menu_layer);
}

void init(void) {
  window = window_create();
    
    // Setup the window handlers
      window_set_window_handlers(window, (WindowHandlers) {
        .load = window_load,
        .unload = window_unload,
      });
    
  window_stack_push(window, true);
  
  // Register AppMessage handlers
  app_message_register_inbox_received(in_received_handler); 
  app_message_register_inbox_dropped(in_dropped_handler); 
  app_message_register_outbox_failed(out_failed_handler);
    
  app_message_open(app_message_inbox_size_maximum(), app_message_outbox_size_maximum());
  
  send_message();
    
    //Register to receive minutely updates
    tick_timer_service_subscribe(MINUTE_UNIT, tick_callback);
}

void deinit(void) {
    tick_timer_service_unsubscribe();
  app_message_deregister_callbacks();
  window_destroy(window);
}

int main( void ) {
  init();
  app_event_loop();
  deinit();
}