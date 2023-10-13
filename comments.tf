Pourquoi un count pour le NAT GW ?
Le subnet public du NAT GW n'est pas choisi aléatoirement. tu prends le premier à chaque fois. ==> https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle

Pas vraiment besoin de provider, de variables region et profile dans les modules vpc et webserver.

La variable pr le nombre d'instances ne doit pas etre par subnet. Le nombre doit etre global. La répartition n'est pas forcément équitable à chaque fois. Il fallait trouver un moye de les répartir dans les 2 subnets.

Pas besoin de fournir les outputs qui ne sont pas demandés.

Note espérée: 15 ou 16
