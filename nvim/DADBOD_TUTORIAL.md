# vim-dadbod Tutorial: Database Management in Neovim

## Overview

vim-dadbod is a modern database interface for Neovim that allows you to interact with databases directly from your editor. With vim-dadbod-ui, you get a visual interface to navigate databases, tables, and run queries.

## What's Installed

1. **vim-dadbod** - The core database engine
2. **vim-dadbod-ui** - Visual interface for database navigation
3. **vim-dadbod-completion** - Autocomplete for SQL queries (table names, columns, etc.)

## Quick Start

### Opening the Database UI

Use any of these methods:
- Press `<leader>db` (Space + db) - Toggle database drawer
- Run command `:DBUI` - Open database drawer
- Run command `:DBUIToggle` - Toggle database drawer

### Adding Your First Database Connection

#### Method 1: Interactive (Easiest)
1. Open DBUI with `<leader>db`
2. Press `A` in the drawer (or run `:DBUIAddConnection`)
3. Enter the database URL when prompted
4. Enter a friendly name for the connection

#### Method 2: Environment Variables
Create a `.env` file in your project or set environment variables:

```bash
# PostgreSQL
export DB_UI_DEV="postgres://username:password@localhost:5432/mydb"

# MySQL
export DB_UI_PROD="mysql://username:password@localhost:3306/mydb"

# SQLite
export DB_UI_LOCAL="sqlite:///path/to/database.db"
```

Then restart Neovim - connections will appear automatically!

#### Method 3: Configuration File
Edit `~/.config/nvim/lua/config/plugins/dadbod.lua` and add:

```lua
vim.g.dbs = {
  dev = 'postgres://user:pass@localhost:5432/dev_db',
  staging = 'mysql://user:pass@localhost:3306/staging_db',
  local = 'sqlite:///home/user/data.db',
}
```

## Database Connection Strings

### PostgreSQL
```
postgres://username:password@host:port/database
postgresql://username:password@host:port/database
```

Example: `postgres://myuser:mypass@localhost:5432/mydb`

### MySQL/MariaDB
```
mysql://username:password@host:port/database
```

Example: `mysql://root:password@localhost:3306/mydb`

### SQLite
```
sqlite:///absolute/path/to/database.db
sqlite://relative/path/to/database.db
```

Example: `sqlite:///home/user/data.db`

### MongoDB
```
mongodb://username:password@host:port/database
```

### Redis
```
redis://host:port/database_number
```

## Using the Database Drawer

### Navigation Keybindings

In the DBUI drawer:
- `o` or `<Enter>` - Open/toggle item (expand database, table, etc.)
- `S` - Open in vertical split
- `R` - Refresh/redraw the drawer
- `A` - Add new database connection
- `H` - Toggle database connection details
- `d` - Delete saved query or buffer
- `?` - Toggle help (show all keybindings)

### Drawer Structure

```
DBUI
├── 📦 dev_db (PostgreSQL)
│   ├── 📊 Tables
│   │   ├── users
│   │   │   ├── List (helper)
│   │   │   ├── Count (helper)
│   │   │   └── Describe (helper)
│   │   └── posts
│   ├── 👁️ Views
│   └── 🔧 Procedures
└── 📦 prod_db (MySQL)
```

## Running Queries

### Quick Queries from Tables

1. Open DBUI (`<leader>db`)
2. Navigate to a database → Tables → select a table
3. Press `o` on a table helper (List, Count, Describe)
4. Query executes automatically and shows results!

### Writing Custom Queries

1. Navigate to a database in DBUI
2. Press `o` on the database name to see "New Query"
3. Press `o` on "New Query" - opens a new SQL buffer
4. Write your query:
   ```sql
   SELECT * FROM users WHERE age > 25;
   ```
5. **Save the file** (`:w` or `<leader>w`) - Query executes automatically!
6. Results appear in a split window

### Saving Queries for Later

To save a query permanently:
1. Write your query in the SQL buffer
2. Press `<Leader>W` (Space + Shift + w)
3. Enter a name for the query
4. Query is saved under "Saved Queries" in the drawer

Saved queries are stored in `~/.local/share/nvim/db_ui/` by default.

## Autocomplete in SQL Files

When editing SQL files connected to a database:

1. Start typing a table name - autocomplete suggests tables
2. Type `table_name.` - autocomplete suggests columns
3. Type SQL keywords - autocomplete suggests SQL syntax
4. Use `<Tab>` and `<Shift-Tab>` to navigate suggestions
5. Press `<Enter>` to accept

Example:
```sql
SELECT u.  -- Autocomplete shows: id, name, email, created_at
FROM users u
WHERE u.
```

## Custom Keymaps (Already Configured)

- `<leader>db` - Toggle database drawer
- `<leader>df` - Find and jump to a database buffer
- `<leader>da` - Add new database connection

In SQL buffers:
- `<Leader>W` - Save query permanently
- `<Leader>E` - Edit bind parameters (for parameterized queries)

## Table Helpers (Already Configured)

Table helpers are quick queries you can run on any table:

### PostgreSQL
- **Count** - `SELECT count(*) FROM table`
- **Describe** - `\d+ table` (show table structure)

### MySQL
- **Count** - `SELECT count(*) FROM table`
- **Describe** - `DESCRIBE table`

### SQLite
- **Count** - `SELECT count(*) FROM table`
- **Schema** - Show table creation SQL

To use: Navigate to any table → Press `o` to expand → Select a helper → Press `o` to run

## Workflow Examples

### Example 1: Exploring a Database

1. Open DBUI: `<leader>db`
2. Press `o` on your database to expand
3. Press `o` on "Tables" to see all tables
4. Navigate to a table and press `o`
5. Run "List" helper to see first rows
6. Run "Count" helper to see total rows
7. Run "Describe" helper to see table structure

### Example 2: Writing and Saving a Query

1. Open DBUI: `<leader>db`
2. Navigate to database → Press `o` on database name
3. Press `o` on "New Query"
4. Write your query:
   ```sql
   SELECT users.name, COUNT(posts.id) as post_count
   FROM users
   LEFT JOIN posts ON users.id = posts.user_id
   GROUP BY users.id, users.name
   ORDER BY post_count DESC
   LIMIT 10;
   ```
5. Save to execute: `:w`
6. Save permanently: `<Leader>W` → Enter name "top_posters"
7. Next time, find it under "Saved Queries" in drawer!

### Example 3: Using Bind Parameters

For queries with parameters:

1. Write query with placeholders:
   ```sql
   SELECT * FROM users WHERE age > :min_age AND country = :country;
   ```
2. Press `<Leader>E` to edit bind parameters
3. Enter values:
   ```
   min_age: 25
   country: USA
   ```
4. Save to execute: `:w`

## Tips & Best Practices

1. **Use Saved Queries** - Save frequently-used queries for quick access
2. **Environment Variables** - Keep sensitive credentials out of config files
3. **Multiple Connections** - Set up dev, staging, and prod databases
4. **Table Helpers** - Customize helpers for your common operations
5. **Split Windows** - Press `S` in drawer to open queries in splits
6. **Autocomplete** - Let dadbod-completion speed up your SQL writing

## Troubleshooting

### Connection Not Working?
- Check your connection string format
- Verify database is running: `netstat -an | grep 5432` (for PostgreSQL)
- Test connection with command line client first
- Check credentials are correct

### No Autocomplete?
- Make sure you're in a SQL buffer (`.sql` file or buffer from DBUI)
- Autocomplete works after connecting to a database via DBUI
- Try `:set ft=sql` to force SQL filetype

### Query Not Executing?
- Make sure to save the file (`:w`) - this triggers execution
- Check for SQL syntax errors in the output buffer
- Verify you're connected to the correct database

## Advanced Configuration

### Custom Table Helpers

Edit `~/.config/nvim/lua/config/plugins/dadbod.lua`:

```lua
vim.g.db_ui_table_helpers = {
  postgresql = {
    ['Recent Records'] = 'select * from {table} order by created_at desc limit 100',
    ['Random Sample'] = 'select * from {table} order by random() limit 10',
  },
  mysql = {
    ['Table Size'] = 'SELECT table_name, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)" FROM information_schema.TABLES WHERE table_schema = "{dbname}" AND table_name = "{table}"',
  },
}
```

### Custom Save Location

```lua
vim.g.db_ui_save_location = '~/my_sql_queries'
```

## Resources

- [vim-dadbod GitHub](https://github.com/tpope/vim-dadbod)
- [vim-dadbod-ui GitHub](https://github.com/kristijanhusak/vim-dadbod-ui)
- [vim-dadbod-ui Documentation](https://github.com/kristijanhusak/vim-dadbod-ui/blob/master/doc/dadbod-ui.txt)

## Quick Reference Card

| Command | Action |
|---------|--------|
| `<leader>db` | Toggle database drawer |
| `:DBUI` | Open database drawer |
| `A` (in drawer) | Add connection |
| `o` or `<Enter>` | Open/toggle item |
| `S` | Open in vertical split |
| `R` | Refresh drawer |
| `?` | Show help |
| `:w` (in SQL buffer) | Execute query |
| `<Leader>W` | Save query permanently |
| `<Leader>E` | Edit bind parameters |

---

**Happy querying! 🗄️**
