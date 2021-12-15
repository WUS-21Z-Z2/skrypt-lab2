# Skrypt lab 2

W projekcie wykorzystujemy Ansible, powłokę bash, narzędzie gcloud.  
Wymagane jest, aby użytkownik skonfigurował regułę zapory sieciowej przepuszczającą ruch przychodzący na wszystkich wykorzystywanych portach.

Przykłady uruchomienia każdej konfiguracji i czyszczenia są dostępne w swoich własnych skryptach:
- `run1different.sh` - konfiguracja 1, każdy komponent na oddzielnej maszynie
- `run3mixed.sh` - konfiguracja 3, część komponentów na wspólnych maszynach
- `run4same.sh` - konfiguracja 4, wszystkie komponenty na jednej maszynie
- `runclean.sh` - czyszczenie wszystkich maszyn

Kilka szczegółów implementacji:
- Przy uruchamianiu konfiguracji, należy dla każdego komponentu podać nazwę maszyny, na której będzie działał, oraz numer portu.
- Ansible inventory jest podzielone na dwie części: dynamiczne, pobierające przez gcloud informacje o włączonych maszynach i ich adresach zewnętrznych, oraz statyczne, propagujące informacje i ustawiające wartości domyślne.
- Ansible playbooks są podzielone na dwie warstwy: wyższa, odpowiedzialna za przydział playbooków komponentów do maszyn i niższa, odpowiedzialna za kompletne wdrożanie pojedyńczego komponentu.
- Ze względu na wymagania Ansible'a dot. bezpieczeństwa, należy ustawić uprawnienia folderu tak, ażeby użytkownicy spoza grupy właściciela nie mieli praw zapisu. W przeciwnym wypadku Ansible odmówi wykonywania poleceń.

Skład zespołu:
- Bartłomiej Moroz
- Jakub Motyka
- Dawid Sygocki
- Jan Walczak
