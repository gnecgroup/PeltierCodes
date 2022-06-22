// Ana Belén Díaz Dochado
// Email: anabelendiaz99@gmail.com

// Incluimos las librerías, instaladas previamente las no estándar (OneWire, LiquidCrystal_I2C y DallasTemperature)

#include <LiquidCrystal_I2C.h> // Librería para el LCD I2C 
#include <DallasTemperature.h> // Librería para el sensor DS18B20
#include <OneWire.h> // Librería para la comunicación con un solo cable
#include <Wire.h> // Librería para la comunicación I2C

float temperatura; //Variable en la que se almacena la temperatura recogida por el sensor

int PIN_sensor = 6; // Pin digital para el sensor de temperatura DS18B20

int pulsador_EncendidoApagado = 3; // Pin digital para el pulsador encargado de encender o apagar, en este caso el modo encendido 
//da la temperatura y el modo apagado escribe 'Apagado' en la pantalla y abre los reles para que no pase corriente por la peltier

int pulsador_calentar = 5; // Pin digital para el pulsador encargado de calentar la peltier (mediante polaridad invertida)

int pulsador_enfriar = 7; // Pin digital para el pulsador encargado de enfriar la peltier (mediante polaridad normal)

int RELE_enfriarR1 = 1; // Pin digital para el rele encargado de enfriar

int RELE_enfriarR2 = 2; // Pin digital para el rele encargado de enfriar

int RELE_calentarR3 = 11; // Pin digital para el rele encargado de calentar

int RELE_calentarR4 = 12; // Pin digital para el rele encargado de calentar

int estado_puls = 1; // Variable que almacena el estado del pulsador Encendido/apagado actual, 1 para no pulsado y 0 para pulsado.

int anterior_puls = 1; // Variable que almacena el estado del pulsador Encendido/apagado anterior, 1 para no pulsado y 0 para pulsado.

int estado_puls_calentar = 1; // Variable que almacena el estado del pulsador para calentar actual, 1 para no pulsado y 0 para pulsado.

int anterior_puls_calentar = 1; // Variable que almacena el estado del pulsador para calentar anterior, 1 para no pulsado y 0 para pulsado.

int estado_puls_enfriar = 1; // Variable que almacena el estado del pulsador para enfriar actual, 1 para no pulsado y 0 para pulsado.

int anterior_puls_enfriar = 1; // Variable que almacena el estado del pulsador para enfriar anterior, 1 para no pulsado y 0 para pulsado.

OneWire ourWire(PIN_sensor); // Se establece el pin digital 6 para la comunicación OneWire

DallasTemperature sensor(&ourWire); // Se instancia la librería DallasTemperature

// Declaración del objeto para el LCD

LiquidCrystal_I2C lcd(0x27,16,2);

void setup() {

  pinMode(PIN_sensor, INPUT); // Pin digital 6 como entrada

  pinMode(pulsador_EncendidoApagado, INPUT_PULLUP); // Pin digital 3 como entrada

  pinMode(pulsador_enfriar, INPUT_PULLUP); // Pin digital 7 como entrada  

  pinMode(RELE_enfriarR1, OUTPUT); // Pin digital 1 como salida

  pinMode(RELE_enfriarR2, OUTPUT); // Pin digital 2 como salida

  pinMode(pulsador_calentar, INPUT_PULLUP); // Pin digital 5 como entrada 

  pinMode(RELE_calentarR3, OUTPUT); // Pin digital 11 como salida

  pinMode(RELE_calentarR4, OUTPUT); // Pin digital 12 como salida

  digitalWrite(RELE_enfriarR1, HIGH); // RELE_enfriarR1 inicialmente desconectado

  digitalWrite(RELE_enfriarR2, HIGH); // RELE_enfriarR2 inicialmente desconectado

  digitalWrite(RELE_calentarR3, LOW); // RELE_calentarR3 inicialmente desconectado

  digitalWrite(RELE_calentarR4, LOW); // RELE_calentarR4 inicialmente desconectado

  lcd.init(); // Se inicializa la LCD 

  lcd.backlight(); // Encender la luz de fondo de la LCD
    
  sensor.begin(); // Se inicializa el sensor de temperatura DS18B20 

}

void loop() {

  estado_puls = digitalRead(pulsador_EncendidoApagado); // Comprobamos el estado actual del pulsador_EncendidoApagado
  estado_puls_calentar = digitalRead(pulsador_calentar); // Comprobamos el estado actual del pulsador_calentar
  estado_puls_enfriar = digitalRead(pulsador_enfriar); // Comprobamos el estado actual del pulsador_enfriar

  leer_puls(); //Función que determina que hacer dependiendo del estado del pulsador_EncendidoApagado
  leer_puls_calentar(); //Función que determina que hacer dependiendo del estado del pulsador_calentar
  leer_puls_enfriar(); //Función que determina que hacer dependiendo del estado del pulsador_enfriar

  // Condicion de seguridad, en el caso de que la temperatura supere los 42 grados o baje de 12 grados se abriran los reles para que deje de pasar corriente.
  if(temperatura > 38 || temperatura < 12){
    digitalWrite(RELE_calentarR3, LOW);
    digitalWrite(RELE_enfriarR1, HIGH);
    digitalWrite(RELE_calentarR4, LOW);
    digitalWrite(RELE_enfriarR2, HIGH);
    estado_puls_calentar=1;
    anterior_puls_calentar=1;
    estado_puls_enfriar=1;
    anterior_puls_enfriar=1;
    pedirTemp();
  }
}

void leer_puls () {
  //En el caso de que se presione el pulsador y el anterior no hubiera sido pulsado se enciende e imprime la temperatura
  if(estado_puls==0 && anterior_puls==1){
    lcd.setCursor(0,0);
    lcd.print("TEMPERATURA"); // Imprimo la cabecera
    pedirTemp();
    estado_puls=1;
    anterior_puls = 0;
  }
  //Al dejar de presionar el pulsador el estado pasa 1 de nuevo por lo tanto sigue dando la temperatura
  if(estado_puls == 1 && anterior_puls == 0){ 
    lcd.setCursor(0,0);
    lcd.print("TEMPERATURA"); // Imprimo la cabecera
    pedirTemp();
  }
  //Si se vuelve a pulsar es para apagar
  if(estado_puls==0 && anterior_puls==0){
    lcd.setCursor(0,0);
    lcd.print("Apagando        ");
    lcd.setCursor(0,1);
    lcd.print("                ");
    anterior_puls = 1;
    estado_puls = 1;
    anterior_puls_calentar = 1;
    estado_puls_calentar = 1;
    digitalWrite(RELE_calentarR3, LOW);
    digitalWrite(RELE_calentarR4, LOW);
    anterior_puls_enfriar = 1;
    estado_puls_enfriar = 1;
    digitalWrite(RELE_enfriarR1, HIGH);
    digitalWrite(RELE_enfriarR2, HIGH);
}
  
  if(estado_puls == 1 && anterior_puls == 1 && estado_puls_calentar == 1 && anterior_puls_calentar == 1 && estado_puls_enfriar == 1 && anterior_puls_enfriar == 1){
    lcd.setCursor(0,0);
    lcd.print("Apagado         ");
    lcd.setCursor(0,1);
    lcd.print("                ");
    delay(500);
  }
}

void leer_puls_calentar () {
  //En el caso de que se presione el pulsador_calentar, el anterior no hubiera sido pulsado, estuviera encendido previamente y el estado del pulsador enfriar y el anterior sean 1 se calienta la placa
  if(estado_puls_calentar==0 && anterior_puls_calentar==1 && estado_puls == 1 && anterior_puls == 0 && estado_puls_enfriar == 1 && anterior_puls_enfriar == 1){
    
    lcd.setCursor(0,0);
    lcd.print("Calentar       "); // Imprimo la cabecera
    pedirTemp();
    estado_puls_calentar=1;
    anterior_puls_calentar= 0;
      
  }
  
  if(estado_puls_calentar==1 && anterior_puls_calentar==0 && estado_puls==1 && anterior_puls==0 && estado_puls_enfriar==1 && anterior_puls_enfriar==1){
    if(temperatura<38){
      lcd.setCursor(0,0);
      lcd.print("Calentar       "); 
      pedirTemp();
      digitalWrite(RELE_calentarR3, HIGH);
      digitalWrite(RELE_calentarR4, HIGH);
    }
    else{ //Cuando se detecte una temperaura mayor a 40 se abrira el rele y se terminara el modo calentar
      digitalWrite(RELE_calentarR3, LOW);
      digitalWrite(RELE_calentarR4, LOW);
      estado_puls_calentar=0;
      anterior_puls_calentar= 0;
    }
  }
  if(estado_puls_calentar == 0 && anterior_puls_calentar == 0 && estado_puls == 1 && anterior_puls == 0 && estado_puls_enfriar == 1 && anterior_puls_enfriar== 1){
    digitalWrite(RELE_calentarR3, LOW);
    digitalWrite(RELE_calentarR4, LOW);
    anterior_puls_calentar = 1;
    estado_puls_calentar = 1;
      
  }
  if(estado_puls_calentar == 1 && anterior_puls_calentar == 1 && estado_puls == 1 && anterior_puls == 0 && estado_puls_enfriar == 1 && anterior_puls_enfriar == 1){
    digitalWrite(RELE_calentarR3, LOW);
    digitalWrite(RELE_calentarR4, LOW);
    pedirTemp();
  }
}

void leer_puls_enfriar () {
  //En el caso de que se presione el pulsador_enfriar, el anterior no hubiera sido pulsado, estuviera encendido previamente y el estado del pulsador calentar y el anterior sean 1 se enfria la placa
   if(estado_puls_enfriar==0 && anterior_puls_enfriar==1 && estado_puls == 1 && anterior_puls == 0 && estado_puls_calentar == 1 && anterior_puls_calentar == 1){
    
    lcd.setCursor(0,0);
    lcd.print("Enfriar       "); // Imprimo la cabecera
    pedirTemp();
    estado_puls_enfriar=1;
    anterior_puls_enfriar = 0;
      
  }
  
  if(estado_puls_enfriar == 1 && anterior_puls_enfriar == 0 && estado_puls == 1 && anterior_puls == 0 && estado_puls_calentar == 1 && anterior_puls_calentar == 1){
    if(temperatura>12){
      lcd.setCursor(0,0);
      lcd.print("Enfriar       "); // Imprimo la cabecera
      pedirTemp();
      digitalWrite(RELE_enfriarR1, LOW);
      digitalWrite(RELE_enfriarR2, LOW);
    }
    else{ //Cuando se detecte una temperaura menor a 12 se abrira el rele y se terminara el modo calentar
      digitalWrite(RELE_enfriarR1, HIGH);
      digitalWrite(RELE_enfriarR2, HIGH);
      estado_puls_enfriar=0;
      anterior_puls_enfriar= 0;
    }
  }
  
  if(estado_puls_enfriar == 0 && anterior_puls_enfriar == 0 && estado_puls == 1 && anterior_puls == 0 && estado_puls_calentar == 1 && anterior_puls_calentar == 1){
    digitalWrite(RELE_enfriarR1, HIGH);
    digitalWrite(RELE_enfriarR2, HIGH);
    anterior_puls_enfriar = 1;
    estado_puls_enfriar = 1;
      
  }
  if(estado_puls_enfriar == 1 && anterior_puls_enfriar == 1 && estado_puls == 1 && anterior_puls == 0 && estado_puls_calentar == 1 && anterior_puls_calentar == 1){
    digitalWrite(RELE_enfriarR1, HIGH);
    digitalWrite(RELE_enfriarR2, HIGH);
    pedirTemp();
  }
}
void pedirTemp () {
  //Funcion que lee la temperatura del sensor y la imprime en la LCD
  sensor.requestTemperatures(); // Prepara el sensor de temperatura DS18B20 para su lectura
        
  temperatura = sensor.getTempCByIndex(0); // Se lee la temperatura del sensor en grados Celsius
      
  // Mostramos el valor de la temperatura a través del LCD 2004  
  lcd.setCursor(0,1);
  lcd.print("TEMP = ");
  lcd.print(temperatura);
  lcd.print(" \337C"); // Símbolo de º (número en OCTAL) + C (tabla de caracteres especiales LCD 1602)
}
