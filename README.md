# Rekrutacja UAM najefektywniejsze kierunki

Hej! Tu jest skrypt, `aim.rb`, który moesz dopasować do swoich upodobań i
zmienić parę zmiennych eby wyskoczyły tobie kierunki na Uniwersytecie im.
Adama Mickiewicza w Poznaniu, które warto wybrać, ponieważ masz największe szansę się
tam dostać.

## Zmienne

base_from_matura = Float(jak dobrze ci poszło na egzaminie w stosunku do
innych kandydatów 1.0-100.0)
second_spot = Float(ile miejsc dodatkowych uwżasz, że będzie obsadzonych
w drugiej turze, lub ile może brakować do _liczby miejsc_ na kierunku studiów)

## Funkcje

Na przykład `def check_if_test_jezyk_polski(file)` zdefiniuj dla siebie
funkcje przedmiotów które cię interesują i dodaj do kodu, mniej więcej,
na lini 200 w odpowiedniej konfiguracji logicznej zgodnej z twoimi
upodobaniami, czy też wynikami egazminów.

## Efekt?

Przykładowy plik `wyniki.csv`

## Najnowsze dane

Jeeli chcesz uaktualnić ilość opłaconych miejsc uruchom skrypt `save_uam.rb`

## Egzamin rozszerzony?

Poszukaj zmiennej bonus i sprawdź czy kierunek akceptuje twój przedmiot i dodaj sobie
_bonus_ o arbitralnej wielkości, który ma mieć wpływ na końcową szansę.