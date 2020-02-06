# Err

[![pub package](https://img.shields.io/pub/v/err.svg)](https://pub.dartlang.org/packages/err) [![api doc](img/api-doc.svg)](https://pub.dartlang.org/documentation/err/latest/err/err-library.html)

Error data structures for fine-grained control over errors. It is possible to use errors as values like in Go

## The Err class

   ```dart
   import 'package:err/err.dart';

   // Create an error:
   final err = Err.error("An error has occured");

   // Use with a function as return value 
   Err theFunction() {
     try {
       // something wrong
     } catch (e) {
       return Err.error(e);
     }
     return null;
     // or to not use a null value return an empty error object
     return const Err.nil();
   }
   ```

Check the error:

   ```dart
   final err = theFunction();
   if (err != null) {
      // print the error to the console
      err.console();
      // throw an exception from the error
      err.raise();
   }
   // or if not using null values
   if (!err.isNil) {
      print("${err.date} ${err.type} : ${err.message}");
   }
   ```

### Data structure:

   ```dart
   /// An error message for the user
   final String userMessage;
 
   /// The date of the error
   DateTime get date;
 
   /// The error type
   ErrType get type;
 
   /// Get an exception from the message
   Exception get exception;
 
   /// Get the message
   String get message;
 
   /// Is the error empty
   bool get isNil;
   ```

Available error levels:

   ```dart
   enum ErrType { critical, error, warning, info, debug }
   ```

### Constructors

All the constructors accept either a `String`, an `Exception` or an `Error` as input

   ```dart
   final err = Err.critical("The error message");

   final err = Err.error("The error message");

   final err = Err.warning("The warning message");

   final err =
      Err.info("The info message", userMessage: "A nice message for the user");

   final err = Err.debug("The debug message");   

   // from a type
   final err = Err.fromType("The error message", ErrType.warning);
   
   // duplicate an error adding a message for the user
   final niceErr = err.copyWithUserMessage("A nice error message")
   print("Message for the developer: ${niceErr.message}");
   print("Message for the user: ${niceErr.userMessage}");
   ```

The `userMessage` parameter is optional for all constructors

### Print an error

Print an error to console, similar to `console.log` in javascript:

   ```dart
   /// print an instance
   err.console();
   /// print from a string or an [Err]
   Err.log("An error");
   ```

## Error as values

A data structure is available to pass return values of functions with errors: the `ÈrrPack` class:

   ```dart
   import 'package:err/err.dart';
   
   ErrPack<int> _someFunctionThatReturnsAnInt() {
     try {
       throw Exception("Oops");
     } catch (e) {
       // return an error and no value
       return ErrPack.err(Err.warning(e));
     }
     // return no error and a integer value
     return const ErrPack.ok(1);
   }
   
   ErrPack<Null> _someFunctionThatReturnsNull() {
     try {
       // ok
     } catch (e) {
       // return an error and no value
       return ErrPack.err(Err.debug("Something went wrong"));
     }
     // return no error and a null value
     return const ErrPack.nullOk();
   }
   
   void main() {
     _someFunctionThatReturnsNull().throwIfError();
     // or
     final res = _someFunctionThatReturnsAnInt();
     if (res.hasError) {
       // print the error
       res.log();
       // throw
       res.raise();
     }
     // get the return value
     final int i = res.value;
   }
   ```