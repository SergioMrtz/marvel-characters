# marvel-characters
Breve aplicación en swift con arquitectura VIPER que muestra una lista de personajes de marvel y al pulsarlos muestra más detalles.

## 1. Módulos
## CharacterList
Muestra la tabla principal con los personajes y una pequeña imagen. También tiene un buscador en caso de que el usuario quiera buscar un personaje concreto. ![alt text](https://user-images.githubusercontent.com/86614564/127553695-c93385b4-44a8-459c-8051-f4ef474d9de4.png)

- El buscador de texto deja un margen de 1 segundo antes de realizar la búsqueda para no realizar demasiadas peticiones y no ralentizar el proceso en caso de que el usuario no haya acabado de escribir.
![alt text](https://user-images.githubusercontent.com/86614564/127553693-b9d83751-446e-4f1d-b813-e2481ef96344.png)
- En caso de error se mostrará el mensaje de error correspondiente en lugar de la tabla de personajes.

- La clase interactor de este módulo, cuando la clase presenter le solicita información, interactúa con dos clases diferentes:
  - CharacterApiDataManager: Se encarga de traer información nueva, construyendo llamadas que pasará al Provider genérico de la aplicación.
  - LocalDataManager: Se encarga de gestionar la información que ya se encuentra disponible en la aplicación (llamadas anteriores, etc.)

## CharacterDetail
Pantalla de detalle a la que se accede pulsando sobre un personaje del listado. Muestra el nombre, foto de perfil, una descripción y una serie de collecciones en las que aparece el personaje (comics, historias, eventos, etc.).
![alt text](https://user-images.githubusercontent.com/86614564/127553690-3f5fbdae-ec91-43fc-913b-88bb83dce966.png)

- En caso de que un personaje no tenga descripción o no tenga alguna de estas colecciones no se mostrará la sección correspondiente.
- Se ha creado una clase independiente para gestionar estas colecciones llamada "ItemCollectionView"
  - Esta clase contiene un título que muestra el total de elementos y un collectionView con un scroll horizontal donde se muestran los elementos de cada colección usando la imagen de perfil del personaje a modo de fondo.
  - El número de elementos de estas colecciones está limitado a 20. Si el usuario hace scroll hasa el final se mostrará una celda en gris con unos puntos suspensivos.
  ![alt text](https://user-images.githubusercontent.com/86614564/127553676-86104c0a-a4dc-4ff6-9f80-df2c9fed390d.png)

## 2. Elementos comunes
- Ambos módulos VIPER poseen una clase Assembly encargada de ensamblar el módulo con la información necesaria:
```swift
static func buildModule() -> CharactersListViewController {
        let view = CharactersListViewController()
        let presenter = CharactersListPresenter()
        let interactor = CharactersListInteractor()
        let router = CharactersListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
```
- Ambos módulos poseen un "Contract" donde se detallan todos los protocolos que usarán para comunicarse las diferentes clases del módulo.
- Existe una clase MCErrorType, de tipo Error, para controlar los errores que pueden ocurrir.
- En cuanto a los modelos de datos se han creado las clases "Entity" encargadas de guardar la información de los servicios y las clases "Model"

## 3. Otra información
- Las claves necesarias para autenticar la llamada a la api están ofuscadas en un array de bytes para evitar subirse al repositorio como string plano.
- Se han añadido test unitarios (XCTest) con un par de tests de prueba sobre la clase CharacterListPresenter:
  - Tests de que se solicitan nuevos personajes en el momento oportuno y no antes, de que se realiza la búsqueda al escribir en el buscador con las condiciones iniciales adecuadas y de que los datos se actualizan correctamente tras una búsqueda con éxito.
- Se han añadido tests de interfaz de usuario (XCUITest) con otro par de pruebas funcionales básicas:
  - Test de que se navega correctamente a la pantalla de detalle de un personaje y de que al buscar por un nombre los resultados son correctos (todos los personajes empiezan por la cadena indicada).

## 4. Librerías utilizadas
- Alamofire: Gestión de llamadas REST a servicios externos, en este caso a la api de marvel.
- SwiftyJSON: Procesamiento de la respuesta JSON de los servicios a las entidades.

## 5. Futuras mejoras y siguientes pasos
- Añadir un botón de reintentar para volver a realizar la llamada en caso de error o un gesto de "pull & refresh" con el mismo objetivo.
- Explotar la clase LocalDataManager para cachear información de las llamadas realizadas y ahorrar requests. El interactor consultaría al LocalDataManager y solo en caso de que la información solicitada no estuviera ya cacheada se solicitaría al CharacterAPIDataManager realizar la llamada.
- Cachear las imágenes que se van cargando usando NSCache.
- Resolver un bug de parpadeo de imágenes cuando se está haciendo scroll por la tabla principal y se reciben los siguientes personajes al hacer el realoadData().
- Encriptar la información de las claves mediante un algoritmo de cifrado como el AES como medida de seguridad adicional a la ofuscación.
- Completar más test unitarios hasta cubrir la mayor parte del código y habilitar el medidor de % de cobertura de código de Xcode.
