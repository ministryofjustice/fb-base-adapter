# Form Builder Base Adapter

This is used for simulating the potential JSON endpoint adapters that integrate with the Form Builder platform.

## Mechanism

The base adapter receives submissions and stores them temporarily as files.
This file is deleted everyday at a specific time.

## API

1. POST /submission
2. GET /submission (latest submission)
3. GET /submission/:id (get the submission by a specific ID)


