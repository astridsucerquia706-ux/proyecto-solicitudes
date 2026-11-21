<?php

namespace App\Support;

use Illuminate\Support\Facades\DB;
use PDO;

class Procedure
{
    public static function call(string $sql, array $bindings = []): array
    {
        $statement = DB::getPdo()->prepare($sql);
        $statement->execute($bindings);

        $rows = [];
        do {
            if ($statement->columnCount() > 0) {
                $rows = array_merge($rows, $statement->fetchAll(PDO::FETCH_OBJ));
            }
        } while ($statement->nextRowset());

        $statement->closeCursor();

        return $rows;
    }
}
