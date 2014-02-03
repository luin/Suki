# WORK IN PROGRESS ᕕ( ᐛ )ᕗ

However, there is a working example in the `example` folder.

[![Build Status](https://travis-ci.org/luin/Suki.png?branch=master)](https://travis-ci.org/luin/Suki) [![Dependencies Status](https://david-dm.org/luin/suki.png)](https://david-dm.org/luin/suki)


* * *

Suki means *like*(好き) in Japanese.

# Get started

## Build a RESTful API within 2 minutes

In this tutorial, we will explain how to create a simple application that provides a RESTful API using the Suki framework.

### 0. Define the API

We will build an API to manage books. The API consists of the following methods:

<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>URL</th>
      <th>Action</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>GET</td>
      <td>/books</td>
      <td>Retrieves all books</td>
    </tr>
    <tr>
      <td>POST</td>
      <td>/books</td>
      <td>Create a new book</td>
    </tr>
    <tr>
      <td>GET</td>
      <td>/books/:bookId</td>
      <td>Retrieves a specific book</td>
    </tr>
    <tr>
      <td>PUT</td>
      <td>/books/:bookId</td>
      <td>Updates a specific book</td>
    </tr>
    <tr>
      <td>DELETE</td>
      <td>/books/:bookId</td>
      <td>Deletes a specific book</td>
    </tr>
</table>

### 1. Install Suki

Suki is bundled with an executable. If you install suki globally with npm you'll have it available from anywhere on your machine:

`$ npm install -g suki`

### 2. Create a application

A good beginning is half done. Suki can create a template application for you:

`$ suki new book`

Where `book` is the name of your application.

After execute the command, Suki will create a directory named "book" in the current path.

### 3. Define the model

Suki follows the MVC pattern and use the [Sequelize](http://sequelizejs.com) library as the model layer.

Now let's define the book model. We can create the book model using the following command:

`$ suki generate model book`

```CoffeeScript
module.exports = class extends Suki.SequelizeModel

  @_define: (DataTypes) ->
    title: DataTypes.STRING
    price: DataTypes.INTEGER
```

### 4. Define the controller

`$ suki create-controller task`

```CoffeeScript
module.exports = class extends Suki.Controller

  # GET /books
  index: ->
    @res.json Book.findAll()

  # POST /books
  create: ->
    @res.json Book.create
      title: @req.body.title
      price: @req.body.price

  # GET /books/:bookId
  show: ->
    @res.json @book

  # PUT /books/:id
  update: ->
    @book.title = req.body.title
    @book.price = req.body.price
    @res.json @book.save()

  # DELETE /books/:id
  destroy: ->
    @book.destroy()
    @res.json { "message": "deleted" }
```

License
-------
The MIT License (MIT)

Copyright (c) 2013 Zihua Li

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
