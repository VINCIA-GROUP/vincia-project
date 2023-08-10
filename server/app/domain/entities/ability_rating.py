class AbilityRating:
    def __init__(self, id, rating, rating_deviation, volatility, ability_id, user_id):
        self.id = id
        self.rating = rating
        self.rating_deviation = rating_deviation
        self.volatility = volatility
        self.ability_id = ability_id
        self.user_id = user_id

    def to_json(self):
        return {
            'id': self.id,
            'rating': self.rating,
            'rating_deviation': self.rating_deviation,
            'volatility': self.volatility,
            'ability_id': self.ability_id,
            'user_id': self.user_id
        }
    