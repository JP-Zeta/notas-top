JavaScript – Manipulación del DOM  
El DOM HTML es un estándar sobre cómo obtener, cambiar, agregar o eliminar elementos HTML.
(Nota de referencia rápida)

1. SELECCIONAR ELEMENTOS
• querySelector(selector) → devuelve el PRIMER elemento que coincida.
• querySelectorAll(selector) → devuelve una NodeList (lista tipo array, pero NO es array real).
  → Para usar métodos de array: Array.from(nodeList) o [...nodeList]

2. CREAR Y AÑADIR ELEMENTOS
• document.createElement("div") → crea elemento en memoria (no aparece aún).
• parentNode.appendChild(child) → añade al final.
• parentNode.insertBefore(newNode, refNode) → inserta antes de otro nodo.

3. ELIMINAR ELEMENTOS
• parentNode.removeChild(child) → elimina y devuelve el nodo eliminado.

4. ESTILOS Y ATRIBUTOS
Estilos:
  div.style.color = "blue";                ✅
  div.style.backgroundColor = "white";     ✅ (camelCase)
  div.style["background-color"] = "white"; ✅ (corchetes + guiones)
  ❌ div.style.background-color → error de sintaxis
  Otras opciones:
    div.style.cssText = "color: blue; background: white;";
    div.setAttribute("style", "color: blue; background: white;");

Atributos:
  div.setAttribute("id", "theDiv");
  div.getAttribute("id");      → "theDiv"
  div.removeAttribute("id");

Clases:
  div.classList.add("new");
  div.classList.remove("new");
  div.classList.toggle("active"); // alterna: si está, lo quita; si no, lo agrega.

5. CONTENIDO
• textContent = "Hola" → solo texto (seguro, recomendado).
• innerHTML = "<b>Hola</b>" → interpreta HTML (¡cuidado con inyección!).

6. EJEMPLO COMPLETO
HTML inicial:
  <div id="container"></div>

JavaScript:
  const container = document.querySelector("#container");
  const content = document.createElement("div");
  content.classList.add("content");
  content.textContent = "This is the glorious text-content!";
  container.appendChild(content);

Resultado en el DOM:
  <div id="container">
    <div class="content">This is the glorious text-content!</div>
  </div>

💡 Importante: El HTML original NO cambia. Solo se modifica el DOM en memoria del navegador.

7. BONUS: <script defer>
Si cargas JS en <head>:
  <script src="script.js" defer></script>
→ El script se ejecuta después de que el HTML esté completamente cargado.



JavaScript – Eventos  
(Nota de referencia rápida — solo eventos)

🔹 ¿Qué es un evento?
Acción que ocurre en el navegador:
- Clic en un botón
- Movimiento del mouse
- Carga de la página
- Presionar una tecla  
→ Puedes responder ejecutando una función (manejador/listener).

🔹 Tres formas de asignar manejadores

1. En HTML (onclick="...")
   • <button onclick="saludo()">
   • ❌ Contamina HTML
   • ❌ Solo un manejador por evento

2. Propiedad JS (onclick = ...)
   • btn.onclick = saludo;
   • ⚠️ Mejor separación, pero sigue limitado a un manejador.

3. addEventListener() ✅ (recomendado)
   • btn.addEventListener("click", saludo);
   • ✔️ Soporta múltiples listeners
   • ✔️ Mejor mantenibilidad y escalabilidad

🔹 Sintaxis práctica
// Con función con nombre (reutilizable)
function handleClick() { alert("¡Clic!"); }
btn.addEventListener("click", handleClick);

// Con función anónima
btn.addEventListener("click", function() { alert("¡Clic!"); });

// Con arrow function
btn.addEventListener("click", () => alert("¡Clic!"));


🔁 Burbujeo vs Captura
Captura: el evento empieza en document y baja hasta el elemento objetivo.
→ Ideal para interceptar eventos antes de que lleguen al destino.
→ Se activa con addEventListener(event, fn, true) (tercer parámetro true).
Burbujeo (por defecto): el evento empieza en el elemento y sube hasta document.
→ Es el comportamiento predeterminado de addEventListener().
→ Útil para delegación de eventos (ej: un listener en <ul> que maneja clicks en <li>).
🎯 Secuencia completa:
captura → objetivo → burbujeo 


🔹 El objeto event (e)
• Se pasa automáticamente como primer parámetro al manejador.
• Solo está disponible dentro del listener.
• Propiedades clave:
  - e.type          → tipo (ej: "click")
  - e.target        → elemento que disparó el evento
  - e.currentTarget → elemento al que está vinculado el listener
  - e.bubbles       → true si el evento burbujea
  - e.cancelable    → true si se puede cancelar con preventDefault()
  - e.eventPhase    → 1: captura, 2: objetivo, 3: burbujeo

🔹 Callbacks
• Una callback es una función pasada como argumento.
• En addEventListener, el manejador es una callback.
• JavaScript la ejecuta cuando ocurre el evento.

🔹 Varios elementos, un mismo evento
const buttons = document.querySelectorAll("button");
buttons.forEach(btn => {
  btn.addEventListener("click", (e) => {
    alert(e.target.id);
  });
});

🔹 Eventos comunes
click      → clic izquierdo
dblclick   → doble clic
keydown    → tecla presionada
keyup      → tecla liberada
load       → página cargada
mouseover  → ratón entra en elemento

🔹 Flujo de eventos (DOM Level 2)
Tiene tres fases:
1. **Captura**      → desde `document` hasta el objetivo
2. **Objetivo**     → en el elemento que disparó el evento
3. **Burbujeo**     → desde el objetivo hasta `document`

Ej: clic en <button> dentro de <div id="container">
Captura:   document → html → body → div#container → button  
Objetivo:  button  
Burbujeo:  button → div#container → body → html → document

🔹 Métodos clave del objeto event

• e.preventDefault()
  → Cancela el comportamiento predeterminado (ej: no seguir un enlace).
  → Solo funciona si `e.cancelable === true`.
  → ❌ No detiene la propagación.

• e.stopPropagation()
  → Detiene la propagación (captura o burbujeo).
  → ❌ No cancela el comportamiento predeterminado.

Ejemplo combinado:
link.addEventListener("click", (e) => {
  e.preventDefault();   // no navega
  e.stopPropagation();  // no sube al padre
});

🔹 Resumen final
- Un evento es una acción detectable (clic, tecla, etc.).
- Usa `addEventListener()` para registrar manejadores.
- El objeto `event` da acceso a datos y control del flujo.
- El flujo tiene 3 fases: captura → objetivo → burbujeo.
- `preventDefault()`: cancela acción predeterminada.
- `stopPropagation()`: detiene la propagación.

Referencia: https://www.w3schools.com/jsref/dom_obj_event.asp



JavaScript – Eventos del mouse  
(Nota de referencia rápida — con ejemplos prácticos)

🔹 Los 9 eventos del mouse (DOM Level 3)
mousedown, mouseup, click, dblclick, mousemove, mouseover, mouseout, mouseenter, mouseleave, wheel

🔹 Secuencia clave
Clic:        mousedown → mouseup → click  
Doble clic:  mousedown → mouseup → click → mousedown → mouseup → click → dblclick


⚠️ Si mueves el mouse fuera durante mousedown/mouseup:  
→ Solo se dispara mousedown (o solo mouseup), nunca click.

🔹 Registro básico (recomendado)
const btn = document.querySelector("#btn");
btn.addEventListener("click", (e) => console.log("Clic"));

🔹 Ejemplo: detectar botón del mouse
btn.addEventListener("mouseup", (e) => {
  switch (e.button) {
    case 0: console.log("Izquierdo"); break;
    case 1: console.log("Central"); break;
    case 2: console.log("Derecho"); break;
  }
});

🔹 Ejemplo: teclas modificadoras
btn.addEventListener("click", (e) => {
  let mods = [];
  if (e.shiftKey) mods.push("shift");
  if (e.ctrlKey) mods.push("ctrl");
  if (e.altKey) mods.push("alt");
  if (e.metaKey) mods.push("meta");
  console.log("Modificadores:", mods.join("+"));
});

🔹 Ejemplo: coordenadas del mouse
div.addEventListener("mousemove", (e) => {
  console.log(`Client: (${e.clientX}, ${e.clientY})`);
  console.log(`Screen: (${e.screenX}, ${e.screenY})`);
});

🔹 Ejemplo: bloquear menú contextual (clic derecho)
btn.addEventListener("contextmenu", (e) => e.preventDefault());

🔹 Ejemplo: evitar sobrecarga con mousemove
// Agrega solo cuando sea necesario
element.onmousemove = handleMouseMove;

// Elimina después
element.onmousemove = null;


🖱️ mouseenter vs mouseover
mouseover se dispara cada vez que el puntero entra en un elemento o en cualquiera de sus hijos.
→ Como burbujea, si mueves el mouse entre un <div> y sus <span> internos, se dispara repetidamente.
mouseenter se dispara solo cuando el puntero entra directamente en el elemento, ignorando sus hijos.
→ No burbujea, así que no se vuelve a disparar al moverse entre los hijos del mismo elemento.
✅ Usa mouseenter/mouseleave cuando quieras una interacción limpia (por ejemplo: mostrar un menú o tooltip sin parpadeos al pasar sobre sub-elementos).

✅ Usa mouseover/mouseout solo si realmente necesitas detectar entrada/salida en cada hijo.


🔹 mouseenter vs mouseover (clave para menús)
<div id="padre"><div id="hijo">...</div></div>

// mouseover en #padre: se dispara al entrar en #hijo  
// mouseenter en #padre: solo al entrar directamente en #padre

🔹 Resumen de comportamiento (burbujeo)
| Evento       | Burbujea | Se dispara en hijos |
|--------------|----------|---------------------|
| mouseover    | ✅       | ✅                  |
| mouseout     | ✅       | ✅                  |
| mouseenter   | ❌       | ❌                  |
| mouseleave   | ❌       | ❌                  |
| click        | ✅       | —                   |
| dblclick     | ✅       | —                   |
| mousedown    | ✅       | —                   |
| mouseup      | ✅       | —                   |
| mousemove    | ✅       | —                   |
| wheel        | ✅       | —                   |

🔹 Resumen final
- click y dblclick compiten: click se dispara antes → conflicto real.  
- e.button: 0=izq, 1=centro, 2=der.  
- e.clientX/Y → viewport; e.screenX/Y → pantalla completa.  
- mousemove: cuidado con rendimiento → añade/elimina dinámicamente.  
- mouseenter/mouseleave: no burbujean → ideales para tooltips/menús.



⌨️ JavaScript – Eventos del teclado  
(Nota de referencia rápida — solo lo esencial)

🔹 Los 3 eventos del teclado
🖱️ keydown   → al presionar una tecla (se repite si se mantiene)  
🔤 keypress  → solo en teclas de *carácter* (a, b, 3…); se repite si se mantiene  
✋ keyup     → al soltar la tecla

🔹 Secuencia al presionar una tecla de carácter (ej: "a"):
🖱️ keydown → 🔤 keypress → ✋ keyup

🔹 Secuencia al presionar tecla no-carácter (ej: flecha, Ctrl):
🖱️ keydown → ✋ keyup  
→ 🔤 keypress no se dispara

🔹 keydown/keypress vs keyup
- 🖊️ keydown y keypress: se disparan **antes** de que el texto cambie en el input  
- ✅ keyup: se dispara **después** del cambio

🔹 Registro básico
const input = document.getElementById("message");
input.addEventListener("keydown", (e) => {
  console.log(`key=${e.key}, code=${e.code}`);
});

🔹 Propiedades clave del evento (e)
• e.key      → carácter generado (ej: "a", "Enter", "ArrowUp")  
• e.code     → código físico de la tecla (ej: "KeyA", "Enter", "ArrowUp")

📌 Ejemplos:
- Tecla "z" → e.key = "z", e.code = "KeyZ"  
- Tecla Enter → e.key = "Enter", e.code = "Enter"  
- Flecha arriba → e.key = "ArrowUp", e.code = "ArrowUp"

🔹 Notas prácticas
⚠️ `keypress` está **obsoleto** → no lo uses en nuevo código.  
✅ Usa `keydown` + `e.key` para la mayoría de los casos.  
🔧 `e.code` es útil si necesitas detectar teclas físicas (ej: QWERTY vs AZERTY).

🔹 Resumen final
🎯 Para detectar teclas: usa `keydown` (o `keyup` si necesitas post-cambio)  
🔤 Usa `e.key` para el valor lógico (qué se escribió)  
⚙️ Usa `e.code` solo si necesitas saber qué tecla física se usó  
🚫 Evita `keypress` — está deprecated





🎯 Delegación de eventos en JavaScript  
💡 Técnica que usa el **burbujeo** para manejar muchos eventos con **un solo listener**

🔹 ¿Por qué usarla?  
✅ Menos memoria (1 listener en vez de N)  
⚡ Mejor rendimiento (menos setup + menos objetos)  
🔄 Funciona con elementos **añadidos dinámicamente** (ej: tras AJAX)

🔹 Ejemplo sin delegación (❌ ineficiente)
HTML:
<ul id="menu">
  <li><a id="home">Home</a></li>
  <li><a id="dashboard">Dashboard</a></li>
  <li><a id="report">Report</a></li>
</ul>

JS:
let home = document.querySelector('#home');
home.addEventListener('click', (e) => {
  console.log('HomeAs clicked');
});

let dashboard = document.querySelector('#dashboard');
dashboard.addEventListener('click', (e) => {
  console.log('Dashboard clicked');
});

let report = document.querySelector('#report');
report.addEventListener('click', (e) => {
  console.log('Report clicked');
});

🔹 Ejemplo con delegación (✅ recomendado)
JS:
const menu = document.querySelector('#menu');

menu.addEventListener('click', (e) => {
  const target = e.target;

  switch (target.id) {
    case 'home':
      console.log('HomeAs clicked');
      break;
    case 'dashboard':
      console.log('Dashboard clicked');
      break;
    case 'report':
      console.log('Report clicked');
      break;
    default:
      console.log('Click en elemento no manejado');
  }
});

🔹 Cómo funciona 🔄
1️⃣ Usuario hace clic en `<a id="home">`  
2️⃣ Evento se dispara en el `<a>` (objetivo)  
3️⃣ Burbujea hacia `<ul id="menu">`  
4️⃣ El listener en `<ul>` lo captura  
5️⃣ Usa `e.target.id` para decidir qué hacer  

🔹 Claves para usarla bien 🔑
• 🎯 Usa `e.target` (no `e.currentTarget`) para identificar el origen  
• 🏷️ Asegúrate de que los hijos tengan atributos útiles: `id`, `data-action`, `class`  
• 🧱 El listener debe estar en un **ancestro común estable**  
• 🧪 Ideal para: listas, tablas, menús, botones de acción (editar/eliminar)

🔹 Bonus: con atributos `data-*` (más flexible)
HTML:
<button data-action="edit" data-id="5">✏️ Editar</button>
<button data-action="delete" data-id="5">🗑️ Eliminar</button>

JS:
container.addEventListener('click', (e) => {
  const action = e.target.dataset.action;
  const id = e.target.dataset.id;

  if (action === 'edit') {
    console.log(`Editar item ${id}`);
  } else if (action === 'delete') {
    console.log(`Eliminar item ${id}`);
  }
});

🔹 Resumen final 📌
🎯 1 listener → maneja N elementos  
⚡ Ideal para contenido dinámico  
🔍 Siempre verifica `e.target` (no asumas el elemento)  
🔧 Usa `data-*` para mayor flexibilidad y mantenibilidad






📤 Evento de despacho en JavaScript  
*(Crear y disparar eventos mediante código)*

🔹 ¿Para qué sirve?
➡️ Simular acciones del usuario (clics, teclas, etc.)  
➡️ Automatizar pruebas o flujos complejos  
➡️ Disparar eventos personalizados

🔹 Pasos básicos
1️⃣ Crea un evento con `new Event()` o constructor especializado  
2️⃣ Dispara con `element.dispatchEvent(event)`

🔹 Evento genérico (mínimo)
const event = new Event('click');
btn.dispatchEvent(event);
→ Por defecto: { bubbles: false, cancelable: false }

🔹 Evento con opciones
const event = new Event('custom', {
  bubbles: true,      // ✅ burbujea
  cancelable: true    // ✅ se puede cancelar con preventDefault()
});

🔹 Evento especializado (✅ recomendado)
const clickEvent = new MouseEvent('click', {
  bubbles: true,
  cancelable: true,
  clientX: 100,       // 📍 coordenada X relativa al viewport
  clientY: 200        // 📍 coordenada Y relativa al viewport
});

🔹 Ejemplo completo ✅
HTML:
<button class="btn">Test</button>

JS:
const btn = document.querySelector('.btn');

btn.addEventListener('click', () => {
  alert('¡Clic detectado!');
});

// Disparar programáticamente
const event = new MouseEvent('click', {
  bubbles: true,
  cancelable: true
});
btn.dispatchEvent(event); // → muestra alerta

🔹 Detectar si es "auténtico" o simulado
btn.addEventListener('click', (e) => {
  if (e.isTrusted) {
    console.log('✅ Acción real del usuario');
  } else {
    console.log('🤖 Evento disparado por código');
  }
});

🔹 Constructores especializados útiles
• MouseEvent     → clic, doble clic, rueda  
• KeyboardEvent  → keydown, keyup  
• FocusEvent     → focus, blur  
• TouchEvent     → touchstart, touchend

🔹 Resumen final 📌
🎯 Usa `new Event()` para eventos simples  
🎯 Usa constructores especializados para más control  
🎯 `dispatchEvent()` lo dispara *como si fuera real*  
🔍 `e.isTrusted` te dice si fue generado por usuario (`true`) o código (`false`)

Todos los eventos del raton
https://www.w3.org/TR/uievents/#idl-mouseevent






✨ Eventos personalizados en JavaScript  
*(Crear y disparar eventos que tú defines)*

🔹 ¿Qué son?
Eventos que **tú defines y disparas manualmente**, a diferencia de los nativos (click, keydown, etc.).  
Te permiten construir tu propio sistema de comunicación entre partes de la app.

🔹 ¿Cómo se crean?
Usa el constructor `CustomEvent()`:

const event = new CustomEvent('mark', {
  detail: { backgroundColor: 'yellow' }
});

→ `detail`: objeto para pasar datos personalizados (accesible como `e.detail` en el listener).

🔹 ¿Cómo se disparan?
Con `dispatchEvent()`:

element.dispatchEvent(event);

🔹 Ejemplo completo ✅ (tal como en tu material)

HTML:
<div class="note">JS Custom Event</div>

JS:
function highlight(elem) {
  elem.style.backgroundColor = 'yellow';

  // ✅ Crea y dispara evento personalizado
  const event = new CustomEvent('mark', {
    detail: { backgroundColor: 'yellow' }
  });
  elem.dispatchEvent(event);
}

const div = document.querySelector('.note');

// ✅ Escucha el evento personalizado
div.addEventListener('mark', function(e) {
  this.style.border = 'solid 1px red';
  console.log(e.detail); // → { backgroundColor: 'yellow' }
});

highlight(div); // → dispara el evento

🔹 ¿Por qué usarlo? (según tu material)
> *"Los eventos personalizados le permiten desacoplar la ejecución del código, lo que permite que un fragmento de código se ejecute después de que se complete otro."*

Ej: puedes tener varios listeners independientes reaccionando al mismo evento, sin modificar la función `highlight()`.

🔹 Resumen final 📌
🎯 Usa `new CustomEvent('nombre', { detail: { ... } })`  
🎯 Usa `element.dispatchEvent(event)` para activarlo  
🎯 Usa `e.detail` para leer los datos que envías  
🔁 Ideal para desacoplar lógica y escalar apps


https://www.javascripttutorial.net/javascript-dom/javascript-custom-events/