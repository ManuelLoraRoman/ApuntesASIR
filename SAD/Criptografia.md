# Introducción a la Criptografía

* Firmar con gpg

```gpg --otput doc.sig --sign doc```

* Verificar y extraer el documento

```gpg --output doc --decrypt doc.sig```

* Documentos con firmas ASCII

```gpg --clearsign doc```

* Firmas acompañantes

```gpg --output doc.sig --detach-sig doc```

* Verificar 

```gpg --verify doc.sig doc```

* Editar los niveles de confianza en nuestro anillo de confianza

```
gpg --edit-key [huella digital]
gpg> trust
Seleccionar de 1-5 según nivel ó m para salir al menú
```

* Para validar, es necesario cumplir:

1. Firmarla nosotros personalmente.

2. Confianza de confianza **Total**

3. Si ha sido firmada por 3 claves marginales

4. El camino hasta llegar desde la clave hasta la nuestra, sea de 5 pasos
o menos.
