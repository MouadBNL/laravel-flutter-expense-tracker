<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'amount' => $this->amount,
            'category_id' => $this->category_id,
            'category_name' => $this->category->name,
            'transaction_date' => $this->transaction_date->format('m/d/Y'),
            'created_at' => $this->created_at,
            'description' => $this->description,
        ];
    }
}
