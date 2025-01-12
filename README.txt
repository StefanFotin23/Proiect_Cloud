Proiect Cloud Computing

Fotin Andrei-Stefan SCPD
Nicolae Alexandru-Dimitrie eGov
Popescu Vlad-Cristian eGov

# Descriere generala

Aplicatia noastra este o platforma web dedicata gestionarii angajatilor din cadrul unei companii. Aceasta inglobeaza o serie de functionalitati care sa permita angajatilor sa depuna diferite tipuri e cereri catre departamentul de HR (cerere de concediu, de demisie, de organizarea a unui training pentru angajati, de adeverinta pentru a dovedi locul de munca etc), sa isi vizualizeze beneficiile de angajat, sa citeasca cele mai noi informatii despre companie, sa aiba la dispozitie un FAQ pentru realizarea procedurilor des intalnite in firma si sa poata depune feedback. Totodata, aplicatia permite departamentului HR sa raspunda la cererile angajatilor, sa vizualizeze feedback-uri, sa actualizeze informatiile angajatilor si posteze un articol in newsfeed pentru toti angajatii, dar exista si posibilitatea gestionarii conturilor e angajati de catre admini, care pot crea, edita si arhiva conturi. Arhitectura este formata dintr-un microserviciu de autentificare, un microserviciu pentru gestionarea interactiunilor utilizatorilor cu aplicatia si un microserviciu pentru frontend.

# Auth-Service

## Descriere
Auth-Service este un microserviciu pentru autentificare și gestionarea utilizatorilor, construit cu Java Spring Boot. Acesta include funcționalități precum înregistrare, autentificare, actualizare parolă, ștergere utilizator şi configurabilitate prin variabile de mediu. Folosește JWT (JSON Web Tokens) pentru autentificare și securitate.

### Dependențe de mediu
- MySQL: Baza de date pentru stocarea utilizatorilor.
- Variabile JWT: `JWT_SECRET` și `JWT_EXPIRATION` pentru securitate.

## Instrumente incluse
- Swagger UI: Accesibil la `/swagger-ui/index.html` pentru testarea API-ului.


# Business Logic Service

## Descriere
Acest microserviciu inglobeaza toata logica functionalitatilor de care dispun angajatii, atat normali, cat si HR. Acesta este scris in Spring Boot, este structurat clasic, cu servicii, controllers, repositories si entitati. Entitatile principale sunt Articles, FAQs, Requests, Feedback si User. Fiecare controller este format din request-uri de tipul Get, Post, Put, Delete, acestea stand la baza realizarii urmatoarelor actiuni: crearea de entitati, modificarea lor, incarcarea lor catre baza de date, stergerea lor, actualizarea (unde este posibil) a fotografiilor de profil sau de cover, adaugarea de documente PDF (la FAQ-uri), generarea de cereri de tipuri diferite inaintate de angajati catre HR si posibilitatea acceptarii sau respingerii lor.

Acest microserviciu comunica printr-un FeignClient cu cel de autentificare deoarece in cod sunt folosite validari ale rolului utilizatorului logat pentru accesul la resursele aplicatiei. Rolul este decodat din JWT-ul sesiunii curente si este verificat prin adnotari ale Spring Boot.

### Dependențe de mediu
- MySQL: Baza de date pentru stocarea utilizatorilor.
- Variabile JWT: `JWT_SECRET` și `JWT_EXPIRATION` pentru securitate.
- Proprietati setate la 30mb pentru incarcarea de fisiere in aplicatie
- Proprietate pentru a face posibila folosirea utilitarului Swagger UI

## Instrumente incluse
- Swagger UI: Accesibil la `/swagger-ui/index.html` pentru testarea API-ului.
- Javax Mail: Accesibil prin dependinta in pom.xml, cu rol pentru trimiterea de mail-uri catre utilizatori.


# Frontend
Acest microserviciu formeaza interfata disponibila utilizatorilor. Frontend-ul aplicatiei a fost scris cu Angular 16. Acesta este format din componente care formeaza paginile disponibile utilizatorilor. Asa cum am precizat la Business Logic si Auth-Service, este folosit un token JWT pentru sesiunea curenta, din care este scos rolul pentru acces doar la paginile si resursele permise.

Exista 3 view-uri, pentru cele 3 tipuri de utilizatori: admin, HR si employee. Admin-ul va avea disponibil doar o pagina cu un tabel cu toti angajatii si va avea disponibile operatii e crearea, editare si stergere. Un HR va avea aceleasi pagini ca un employee (newsfeed, faq, benefits, feedback, requests), doar ca acesta va avea permisiuni de editare a entitatilor in aceste pagini, pe cand un employee va putea doar vizualiza continutul si sa completeze formularul e feedback sau o cerere si sa o trimita catre HR.

## Biblioteci folosite
- Angular Material
- Bootstrap
- Font Awesome

# Servicii Docker
- auth-database-adminer
- auth-database
- auth
- backend-database-adminer
- backend-database
- backend
- frontend
- portainer

Infrastructura a fost create cu Terraform, unde am creat cate un modul pentru fiecare serviciu. Deploymentul s-a realizat folosind Kubernetes, iar clusterul a fost definit cu ajutorul utilitarului kind.
Am creat 4 imagini docker: - frontend - unde am folosit npm run build pentru a obtine executabilul pentru productie
			   - auth si backend - unde am folosit cate un fisier .jar, creat folosind maven
			   - 1 imagine comuna pentru ambele servicii de baze de date, unde am inclus si un script SQL pentru initializarea bazei de date

Pentru servicii populare, cum ar fi adminer sau portainer, am folosit imaginile disponibile pe Docker Hub si configurari standard din industrie.
Initial am realizat imaginile docker, pe care le-am testat si deployat folosind docker-compose, deoarece era mai usor de folosit si de testat.
Ulterior am migrat aceste servicii pe un deployment bazat pe Terraform, cu provider K8s.
Serviciile adminer se conecteaza automat la baza de date alocata lor (auth / backend), folosind credentialele de acces oferite.
Iar serviciul portainer ofera toate metricile de vizualizare si administrare a infrastructurii, de la cluster, numarul de noduri, servicii etc.

Clusterul a fost simulat cu kind si contine 1 nod de control-plane si 2 workeri. Am ales ca serviciile specifice clientului sa ruleze pe un worker, care a primit labelul client, pentru serviciile:
Adminers si Frontend. Iar pe cel de-al doilea worker ruleaza serviciile specifice serverului, care au primit label server. Aceste servicii sunt bazele de date, cat si cele 2 servicii de Backend, pentru autentificare si
business logic.


