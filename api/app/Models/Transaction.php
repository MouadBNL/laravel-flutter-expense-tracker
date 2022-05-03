<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Contracts\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected $dates = ['transaction_date'];

    public function category() {
        return $this->belongsTo(Category::class);
    }

    protected function amount() : Attribute {
        return Attribute::make(
            get: fn ($v) => number_format($v / 100, 2),
            set: fn ($v) => $v * 100
        );
    }

    protected function transactionDate() : Attribute {
        return Attribute::make(
            set: fn ($v) => Carbon::createFromFormat('d/m/Y', $v)->format('Y-m-d')
        );
    }


    public static function booted() {
        if(auth()->check()){
            static::addGlobalScope('by_user', function(Builder $builder) {
                $builder->where('user_id', auth()->id());
            });
        }
    }
}
